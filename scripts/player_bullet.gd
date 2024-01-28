class_name PlayerBullet
extends Area2D


@export var speed: float = 975

var direction: Vector2
var speed_multiplier: float = 1.0
var power: int = 1
var pierce_count: int = 0
var pierce_chance: float = 0


func _process(delta):
	self.position += direction * speed * speed_multiplier * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet_despawner"):
		self.queue_free()
	
	if area.is_in_group("enemy"):
		pierce_count -= 1
		
		if pierce_count <= 0:
			self.queue_free()
		
		if pierce_chance != 1.0 and randf() > pierce_chance:
			self.queue_free()
