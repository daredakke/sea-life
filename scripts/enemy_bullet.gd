class_name EnemyBullet
extends Area2D


@export var speed: int = 200
@export var power: float = 24.5
@export var explosion_scale: float = 0.075

var direction: Vector2
var speed_multiplier: float = 1.0

var _explosion_scene: PackedScene = preload("res://scenes/explosion.tscn")

@onready var _rotation_speed: float = 5


func _ready() -> void:
	rotation_degrees = randf_range(0, 360)
	
	if randf() > 0.5:
		_rotation_speed = -_rotation_speed


func _process(delta):
	position += direction * speed * speed_multiplier * delta
	rotation += _rotation_speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("special_attack"):
		explode()
		self.queue_free()
	
	if area.is_in_group("bullet_despawner") or area.is_in_group("player_hitbox"):
		self.queue_free()


func explode() -> void:
	var explosion_instance := _explosion_scene.instantiate() as Explosion
	explosion_instance.global_position = global_position
	explosion_instance.scale = Vector2(explosion_scale, explosion_scale)
	
	add_sibling(explosion_instance)
