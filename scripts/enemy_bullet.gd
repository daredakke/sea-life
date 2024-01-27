class_name EnemyBullet
extends Area2D

@export var speed: int = 200
@export var power: float = 24.5

var direction: Vector2
var speed_multiplier: float = 1.0
var rotation_speed: float = 5


func _ready() -> void:
	rotation_degrees = randf_range(0, 360)
	
	if randf() > 0.5:
		rotation_speed = -rotation_speed


func _process(delta):
	position += direction * speed * speed_multiplier * delta
	rotation += rotation_speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet_despawner") or area.is_in_group("player_hitbox"):
		self.queue_free()
