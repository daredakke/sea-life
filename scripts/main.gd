class_name Main
extends Node2D

var player_bullet_scene: PackedScene = preload("res://scenes/player_bullet.tscn")

@onready var player: Player = %Player
@onready var projectiles: Node = %Projectiles
@onready var enemies: Node = %Enemies

# Player stats
var spread_range: float = 0.05
var spread: float = 0


func _ready() -> void:
	player.fire_bullet.connect(_on_fire_bullet)


func _on_fire_bullet(pos: Vector2, direction: Vector2) -> void:
	var bullet_instance: Area2D = player_bullet_scene.instantiate()
	
	if spread_range > 0:
		spread = randf_range(-spread_range, spread_range)
	
	var new_direction: Vector2 = direction.rotated(spread)
	
	bullet_instance.global_position = pos
	bullet_instance.direction = new_direction
	bullet_instance.rotation = new_direction.angle()
	
	projectiles.add_child(bullet_instance)
