class_name Main
extends Node2D

const BASE_SPREAD_RANGE: float = 0.12

var player_bullet_scene: PackedScene = preload("res://scenes/player_bullet.tscn")

@onready var player: Player = %Player
@onready var projectiles: Node = %Projectiles
@onready var enemies: Node = %Enemies

@onready var options: Options = %Options
@onready var stats: Stats = %Stats

# Bullet stats
var bullet_power: int = 1
var bullet_pierce_count: int = 0
var bullet_pierce_chance: float = 0
var spread_range: float = BASE_SPREAD_RANGE
var spread: float = 0
var bullet_speed_multiplier: int = 1


func _ready() -> void:
	player.fire_bullet.connect(_on_fire_bullet)
	stats.close_stats_screen.connect(toggle_stats_screen)
	stats.reset_stats.connect(reset_stats)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_stats"):
		toggle_stats_screen()


func toggle_stats_screen() -> void:
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

	bullet_instance.power = bullet_power
	bullet_instance.pierce_count = bullet_pierce_count
	bullet_instance.pierce_chance = bullet_pierce_chance
	bullet_instance.speed_multiplier = bullet_speed_multiplier

	projectiles.add_child(bullet_instance)


func _on_stat_increased(value: int, stat: int) -> void:
	match stat:
		0:
			bullet_power += 1
		1:
			player.set_fire_rate(value)
		2:
			spread_range = BASE_SPREAD_RANGE - (value * 0.01)
		3:
			bullet_speed_multiplier = value * 0.1 + 1.8
		4:
			bullet_pierce_count += 1
		5:
			bullet_pierce_chance += 0.1


func reset_stats() -> void:
	bullet_power = 1
	bullet_pierce_count = 0
	bullet_pierce_chance = 0
	spread_range = BASE_SPREAD_RANGE
	bullet_speed_multiplier = 1

	player.set_fire_rate(0)
