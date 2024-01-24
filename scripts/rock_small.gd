class_name RockSmall
extends Area2D

var explosion_scene: PackedScene = preload("res://scenes/explosion.tscn")

var speed: float = 120
var speed_variance: float = 15
var direction: Vector2
var rotation_speed: float = randf_range(0.2, 0.8)
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
			spawn_explosion()
			self.queue_free()


	if area.is_in_group("enemy_despawner"):
		spawn_explosion()
		self.queue_free()


func spawn_explosion() -> void:
	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.global_position = global_position
	
	add_sibling(explosion_instance)
