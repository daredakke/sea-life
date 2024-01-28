class_name Main
extends Node2D


const BASE_SPREAD_RANGE: float = 0.12
const POINTS_PER_WAVE: int = 2

var _wave: int = 0
var _bullet_power: int = 1
var _bullet_pierce_count: int = 0
var _bullet_pierce_chance: float = 0
var _spread: float = 0
var _spread_range: float = BASE_SPREAD_RANGE
var _bullet_speed_multiplier: float = 1
var _node_spawner_scene: PackedScene = preload("res://scenes/enemies/node_spawner.tscn")
var _player_bullet_scene: PackedScene = preload("res://scenes/player_bullet.tscn")

@onready var _player: Player = %Player
@onready var _projectiles: Node = %Projectiles
@onready var _enemies: Node = %Enemies
@onready var _options: Options = %Options
@onready var _stats: Stats = %Stats
@onready var _wave_start_timer: Timer = %WaveStartTimer


func _ready() -> void:
	_player.fire_bullet.connect(_on_fire_bullet)
	_stats.close_stats_screen.connect(_on_close_stats_screen)
	_stats.reset_stats.connect(_reset_stats)
	_player.player_position.connect(Globals.update_player_position)
	Waves.wave_over.connect(_wave_end)
	
	_wave_start_timer.start()


func _on_wave_start_timer_timeout() -> void:
	_wave += 1
	var wave_params: Array = Waves.get_wave_parameters(_wave)
	
	Waves.set_enemies_in_wave(_wave)
	_stats.set_wave_text(_wave)
	
	for params in wave_params:
		var node_spawner_instance := _node_spawner_scene.instantiate() as Node2D
		
		node_spawner_instance.node_scene = params["node_scene"]
		node_spawner_instance.nodes_to_spawn = params["nodes_to_spawn"]
		node_spawner_instance.node_speed = params["node_speed"]
		node_spawner_instance.node_speed_variance = params["node_speed_variance"]
		node_spawner_instance.spawn_delay = params["spawn_delay"]
		node_spawner_instance.aim_at_player = params["aim_at_player"]
		
		if params.has("node_health"):
			node_spawner_instance.node_health = params["node_health"]
		
		_enemies.add_child(node_spawner_instance)


func _wave_end() -> void:
	if _wave > 30:
		_wave_start_timer.start()
		return
	
	_stats.show()
	_player.set_process(false)
	
	_stats.add_points(POINTS_PER_WAVE)


func _on_close_stats_screen() -> void:
	_player.set_process(true)
	_wave_start_timer.start()


func _on_fire_bullet(pos: Vector2, direction: Vector2) -> void:
	var bullet_instance := _player_bullet_scene.instantiate() as Area2D

	if _spread_range > 0:
		_spread = randf_range(-_spread_range, _spread_range)

	var new_direction: Vector2 = direction.rotated(_spread)

	bullet_instance.global_position = pos
	bullet_instance.direction = new_direction
	bullet_instance.rotation = new_direction.angle()

	bullet_instance.power = _bullet_power
	bullet_instance.pierce_count = _bullet_pierce_count
	bullet_instance.pierce_chance = _bullet_pierce_chance
	bullet_instance.speed_multiplier = _bullet_speed_multiplier

	_projectiles.add_child(bullet_instance)


func _on_stat_increased(value: int, stat: int) -> void:
	match stat:
		0:
			_bullet_power += 1
		1:
			_player.set_fire_rate(value)
		2:
			_spread_range = BASE_SPREAD_RANGE - (value * 0.01)
		3:
			_bullet_speed_multiplier = value * 0.1 + 1.5
		4:
			_bullet_pierce_count += 1
		5:
			_bullet_pierce_chance += 0.1


func _reset_stats() -> void:
	_bullet_power = 1
	_bullet_pierce_count = 0
	_bullet_pierce_chance = 0
	_spread_range = BASE_SPREAD_RANGE
	_bullet_speed_multiplier = 1

	_player.set_fire_rate(0)
