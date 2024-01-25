class_name Enemy
extends Area2D

var explosion_scene: PackedScene = preload("res://scenes/explosion.tscn")

@export var health: int = 3
@export var explosion_scale: float = 0.33

var speed: float = 120
var speed_variance: float = 15
var direction: Vector2


func _ready() -> void:
	speed += randf_range(0, speed_variance)


func _process(delta):
	self.position += direction * speed * delta


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
	explosion_instance.scale = Vector2(explosion_scale, explosion_scale)
	
	add_sibling(explosion_instance)
