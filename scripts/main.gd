class_name Main
extends Node2D

var player_bullet_scene: PackedScene = preload("res://scenes/player_bullet.tscn")

@onready var player: Player = %Player
@onready var projectiles: Node = %Projectiles
@onready var enemies: Node = %Enemies


func _ready() -> void:
	player.fire_bullet.connect(_on_fire_bullet)


func _on_fire_bullet(pos: Vector2, direction: Vector2) -> void:
	var bullet_instance: Area2D = player_bullet_scene.instantiate()
	bullet_instance.global_position = pos
	bullet_instance.direction = direction
	
	projectiles.add_child(bullet_instance)
