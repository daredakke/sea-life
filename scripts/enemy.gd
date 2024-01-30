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
			defeated.emit(score_value)
			_spawn_explosion()
			self.queue_free()


	if area.is_in_group("enemy_despawner"):
		defeated.emit(0)
		_spawn_explosion()
		self.queue_free()


func _spawn_explosion() -> void:
	var explosion_instance = _explosion_scene.instantiate()
	explosion_instance.global_position = global_position
	explosion_instance.scale = Vector2(explosion_scale, explosion_scale)
	
	add_sibling(explosion_instance)
