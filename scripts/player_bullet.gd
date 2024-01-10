class_name PlayerBullet
extends Area2D

@export var speed: int = 1000
var direction: Vector2
var speed_multiplier: float = 1.0


func _process(delta):
	self.position += direction * speed * speed_multiplier * delta
