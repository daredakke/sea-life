class_name Enemy
extends Area2D


signal defeated(score: int, enemy_type: String)

@export_enum("Enemy", "Boss") var enemy_type: String = "Enemy"
@export var health: int = 3
@export var score_value: int = 500
@export var explosion_scale: float = 0.33
@export var speed: float = 90
@export var speed_variance: float = 15

var direction: Vector2

var _explosion_scene: PackedScene = preload("res://scenes/explosion.tscn")
var _enemy_bullet_scene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")


func _ready() -> void:
	speed += randf_range(0, speed_variance)


func _process(delta):
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		health -= area.power
		
		if health <= 0:
			_die(score_value)
	
	if area.is_in_group("special_attack"):
		if self.is_in_group("boss"):
			health -= 750
			
			if health <= 0:
				_die(score_value)
		else:
			_die(score_value)
	
	if area.is_in_group("player_hitbox") and not self.is_in_group("boss"):
		_die(0)
		
	if area.is_in_group("enemy_despawner"):
		_die(0)


func _die(score: int) -> void:
	defeated.emit(score, enemy_type)
	explode()
	queue_free()


func _direction_to_player() -> Vector2:
	return global_position.direction_to(Globals.player_position)


func explode() -> void:
	var explosion_instance := _explosion_scene.instantiate() as Explosion
	explosion_instance.global_position = global_position
	explosion_instance.scale = Vector2(explosion_scale, explosion_scale)
	
	add_sibling(explosion_instance)
