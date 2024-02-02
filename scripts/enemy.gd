class_name Enemy
extends Area2D


signal defeated(score: int)

@export var health: int = 3
@export var score_value: int = 500
@export var explosion_scale: float = 0.33
@export var speed: float = 120
@export var speed_variance: float = 15

var direction: Vector2

var _explosion_scene: PackedScene = preload("res://scenes/explosion.tscn")


func _ready() -> void:
	speed += randf_range(0, speed_variance)


func _process(delta):
	self.position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		health -= area.power
		
		if health <= 0:
			_die(score_value)
	
	if area.is_in_group("special_attack"):
		_die(score_value)
	
	if area.is_in_group("player_hitbox") or area.is_in_group("enemy_despawner"):
		_die(0)


func _die(score) -> void:
	defeated.emit(score)
	_spawn_explosion()
	self.queue_free()


func _spawn_explosion() -> void:
	var explosion_instance = _explosion_scene.instantiate()
	explosion_instance.global_position = global_position
	explosion_instance.scale = Vector2(explosion_scale, explosion_scale)
	
	add_sibling(explosion_instance)
