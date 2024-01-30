class_name Main
extends Node2D


const BASE_SPREAD_RANGE: float = 0.12
const POINTS_PER_WAVE: int = 10
const MAX_SCORE_MULTIPLIER: int = 9999

var _game_started: bool = false
var _game_paused: bool = true
var _score: int = 0
var _score_multiplier: int = 1
var _wave: int = 0
var _bullet_power: int = 1
var _bullet_pierce_count: int = 0
var _bullet_pierce_chance: float = 0
var _spread: float = 0
var _spread_range: float = BASE_SPREAD_RANGE
var _bullet_speed_multiplier: float = 1
var _node_spawner_scene: PackedScene = preload("res://scenes/enemies/node_spawner.tscn")
var _player_bullet_scene: PackedScene = preload("res://scenes/player_bullet.tscn")

@onready var wave_start_timer: Timer = %WaveStartTimer
@onready var wave_end_timer: Timer = %WaveEndTimer
@onready var projectiles: Node = %Projectiles
@onready var player: Player = %Player
@onready var enemies: Node = %Enemies
@onready var pause: Pause = %Pause
@onready var stats: Stats = %Stats
@onready var score: Score = %Score


func _ready() -> void:
	pause.start_new_game.connect(_start_new_game)
	pause.continue_game.connect(_continue_game)
	player.fire_bullet.connect(_on_fire_bullet)
	stats.close_stats_screen.connect(_on_close_stats_screen)
	player.player_position.connect(Globals.update_player_position)
	player.player_hit.connect(_reset_multiplier)
	Waves.wave_over.connect(_wave_end)
	Waves.score_increased.connect(_increase_score)
	
	_handle_pause_state()


func _process(_delta: float) -> void:
	if _game_started and Input.is_action_just_pressed("pause"):
		_game_paused = !_game_paused
		_handle_pause_state()


func _start_new_game() -> void:
	_game_paused = false
	
	_handle_pause_state()
	
	# Clear any bullets or enemies from an existing game
	for node in projectiles.get_children():
		projectiles.remove_child(node)
		node.queue_free()
	
	for node in enemies.get_children():
		enemies.remove_child(node)
		node.queue_free()
	
	player.reset_player_position()
	stats.reset_points_and_stat_labels()
	_reset_stats()
	wave_start_timer.start()
	
	_score = 0
	_game_started = true


func _on_wave_start_timer_timeout() -> void:
	_wave += 1
	var wave_params: Array = Waves.get_wave_parameters(_wave)
	
	Waves.set_enemies_in_wave(_wave)
	stats.set_wave_text(_wave)
	
	for params in wave_params:
		var node_spawner_instance := _node_spawner_scene.instantiate() as Node2D
		
		node_spawner_instance.node_scene = params["node_scene"]
		node_spawner_instance.nodes_to_spawn = params["nodes_to_spawn"]
		node_spawner_instance.node_speed = params["node_speed"]
		node_spawner_instance.node_speed_variance = params["node_speed_variance"]
		node_spawner_instance.spawn_delay = params["spawn_delay"]
		node_spawner_instance.aim_at_player = params["aim_at_player"]
		
		if params.has("start_delay"):
			node_spawner_instance.start_delay = params["start_delay"]
			
		if params.has("node_health"):
			node_spawner_instance.node_health = params["node_health"]
		
		enemies.add_child(node_spawner_instance)


func _wave_end() -> void:
	if _wave > Waves.get_wave_count():
		wave_start_timer.start()
		return
	
	wave_end_timer.start()


func _show_stats_screen() -> void:
	# Remove any stray bullets so they don't threaten the player
	for node in enemies.get_children():
		enemies.remove_child(node)
		node.queue_free()
	
	stats.show()
	player.set_process(false)
	
	stats.add_points(POINTS_PER_WAVE)


func _continue_game() -> void:
	_game_paused = false
	_handle_pause_state()


func _handle_pause_state() -> void:
	get_tree().paused = _game_paused
	
	if _game_paused:
		pause.show()
	else:
		pause.hide()


func _on_close_stats_screen() -> void:
	player.set_process(true)
	wave_start_timer.start()


func _increase_score(value: int) -> void:
	_score += floori(value * _score_multiplier)
	
	if _score_multiplier < MAX_SCORE_MULTIPLIER:
		_score_multiplier += 1
		score.set_multiplier_label(_score_multiplier)
	
	score.set_score_label(_score)


func _reset_multiplier() -> void:
	_score_multiplier = 1
	
	score.set_multiplier_label(_score_multiplier)


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

	projectiles.add_child(bullet_instance)


func _on_stat_increased(value: int, stat: int) -> void:
	match stat:
		0:
			_bullet_power += 1
		1:
			player.set_fire_rate(value)
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

	player.set_fire_rate(0)
