class_name RockSmall
extends Area2D

var speed: float = 120
var speed_variance: float = 15
var direction: Vector2
var rotation_speed: float = randf_range(0.1, 0.7)
# false -> clockwise
var reverse_rotation: bool = false
var health: int = 3


func _ready() -> void:
	speed += randf_range(0, speed_variance)
	rotation_degrees = randf_range(0, 360)
	
	if reverse_rotation:
		rotation_speed = -rotation_speed


func _process(delta):
	self.position += direction * speed * delta
	self.rotation += rotation_speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		health -= area.power
		
		if health <= 0:
			self.queue_free()


	if area.is_in_group("enemy_despawner"):
		self.queue_free()
