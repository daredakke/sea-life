class_name Main
extends Node2D

var player_bullet_scene: PackedScene = preload("res://scenes/player_bullet.tscn")

@onready var player: Player = %Player
@onready var projectiles: Node = %Projectiles
@onready var enemies: Node = %Enemies

@onready var options: Options = %Options
@onready var stats: Stats = %Stats

# Player stats
var fire_rate_multiplier: int = 0
var spread_range: float = 0.1
var spread: float = 0


func _ready() -> void:
	player.fire_bullet.connect(_on_fire_bullet)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_stats"):
		stats.toggle_visibility()
		
		if player.is_processing():
			player.set_process(false)
		else:
			player.set_process(true)


func _on_fire_bullet(pos: Vector2, direction: Vector2) -> void:
	var bullet_instance: Area2D = player_bullet_scene.instantiate()
	
	if spread_range > 0:
		spread = randf_range(-spread_range, spread_range)
	
	var new_direction: Vector2 = direction.rotated(spread)
	
	bullet_instance.global_position = pos
	bullet_instance.direction = new_direction
	bullet_instance.rotation = new_direction.angle()
	
	projectiles.add_child(bullet_instance)


#func increase_fire_rate() -> void:
	#if player.fire_rate_multiplier < 10:
		#fire_rate_multiplier += 1
		#
		#player.set_fire_rate(fire_rate_multiplier)


func _on_stat_increased(value: int, stat: int) -> void:
	match stat:
		0:
			pass
		1:
			player.set_fire_rate(value)
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
