class_name Main
extends Node2D


const BASE_SPREAD_RANGE: float = 0.12
const POINTS_PER_WAVE: int = 30
const MAX_SCORE_MULTIPLIER: int = 999
const MAX_SPECIAL_CHARGES: int = 3
const INITIAL_WAVE: int = -1
const MAX_FINAL_WAVE_CHANGES: int = 12
const SPAWN_DELAY_MIN: float = 0.05
const START_DELAY_MIN: float = 5.0
const NOISE_SHAKE_SPEED: float = 30.0
const SHAKE_STRENGTH_DEFAULT: float = 8.33
const SHAKE_STRENGTH_BOSS: float = 52.5
const SHAKE_STRENGTH_PLAYER: float = 60.0
const SHAKE_DECAY_RATE_DEFAULT: float = 13.5
const SHAKE_DECAY_RATE_BOSS: float = 3.0
const SHAKE_DECAY_RATE_PLAYER: float = 1.0

var _background_direction: Vector2
var _game_started: bool = false
var _game_paused: bool = true
var _score: int = 0:
	set(new_value):
		_score = new_value
		score.set_score_label(new_value)
var _score_multiplier: int = 1:
	set(new_value):
		_score_multiplier = new_value
		score.set_multiplier_label(new_value)
var _wave: int = INITIAL_WAVE
var _special_charges: int = 1:
	set(new_value):
		_special_charges = new_value
		special.set_special_charges(_special_charges)
		
		if _special_charges == MAX_SPECIAL_CHARGES:
			Waves.can_increase_enemy_defeated_combo = false
		else:
			Waves.can_increase_enemy_defeated_combo = true
var _bullet_power: int = 1
var _bullet_pierce_count: int = 0
var _bullet_pierce_chance: float = 0
var _spread: float = 0
var _spread_range: float = BASE_SPREAD_RANGE
var _bullet_speed_multiplier: float = 1
var _noise_i: float = 0.0
var _shake_strength: float = 0.0
var _shake_decay_rate: float = 0.0
var _node_spawner_scene: PackedScene = preload("res://scenes/enemies/node_spawner.tscn")
var _player_bullet_scene: PackedScene = preload("res://scenes/player_bullet.tscn")
var _special_attack_scene: PackedScene = preload("res://scenes/special_attack.tscn")
var _final_wave_changes: Dictionary = {
	"nodes_to_spawn": 2,
	"node_health": 1,
	"node_speed": 2,
	"node_speed_variance": 2,
	"spawn_delay": -0.1,
	"start_delay": -0.1,
}
var _background_hue: float
var _cursor_arrow := preload("res://assets/cursor.png")
var _cursor_crosshair := preload("res://assets/crosshair.png")

@onready var background: Sprite2D = %Background
@onready var wave_start_timer: Timer = %WaveStartTimer
@onready var wave_end_timer: Timer = %WaveEndTimer
@onready var projectiles: Node = %Projectiles
@onready var player: Player = %Player
@onready var camera: Camera2D = %Camera
@onready var enemies: Node = %Enemies
@onready var screen_centre: Marker2D = %ScreenCentre
@onready var player_health_bar: PlayerHealthBar = %PlayerHealthBar
@onready var player_special_bar: PlayerSpecialBar = %PlayerSpecialBar
@onready var special: Special = %Special	
@onready var score: Score = %Score
@onready var stats: Stats = %Stats
@onready var game_over: GameOver = %GameOver
@onready var fade_out: FadeOut = $UI/FadeOut
@onready var pause: Pause = %Pause
@onready var splash: Splash = %Splash
@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()


func _ready() -> void:
	rand.randomize()
	noise.seed = randi()
	noise.frequency = 0.5
	_background_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	_background_hue = randf()

	background.material.set_shader_parameter("direction", _background_direction)
	
	Globals.screen_centre = screen_centre.global_position
	pause.start_new_game.connect(_start_new_game)
	pause.continue_game.connect(_continue_game)
	stats.close_stats_screen.connect(_on_close_stats_screen)
	game_over.restart_game.connect(_restart_game)
	player.fire_bullet.connect(_on_fire_bullet)
	player.special_fired.connect(_on_special_fired)
	player.player_position.connect(Globals.update_player_position)
	player.player_hit.connect(_reset_multiplier)
	player.player_health_changed.connect(_update_player_health_bar)
	player.bullet_grazed.connect(_increase_score)
	player.player_died.connect(_fade_out_on_death)
	fade_out.animation_finished.connect(_show_game_over_screen)
	Waves.wave_over.connect(_wave_end)
	Waves.score_increased.connect(_increase_score)
	Waves.special_increased.connect(_update_player_special_bar)
	Waves.special_charged.connect(_increase_special_charge)
	Waves.shake_screen.connect(_enemy_defeated_screen_shake)
	
	_handle_pause_state()


func _process(delta: float) -> void:
	if not _game_started:
		return
	
	var speed_up: float = (_wave * 0.000001)
	_background_hue += 0.0001 + speed_up
	
	if _background_hue > 1.0:
		_background_hue = 0.0
	
	background.modulate = Color.from_hsv(_background_hue, 0.5, 0.25, 1)
	
	_background_direction = _background_direction.rotated(0.0001 + speed_up).normalized()
	background.material.set_shader_parameter("direction", _background_direction)
	
	# Screen shake decay
	_shake_strength = lerp(_shake_strength, 0.0, _shake_decay_rate * delta)
	camera.offset = _get_noise_offset(delta)
	
	if Input.is_action_just_pressed("pause"):
		_game_paused = !_game_paused
		
		_handle_pause_state()


func _apply_noise_shake(strength: float) -> void:
	_shake_strength = strength


func _get_noise_offset(delta: float) -> Vector2:
	_noise_i += delta * NOISE_SHAKE_SPEED
	
	return Vector2(
		noise.get_noise_2d(1, _noise_i) * _shake_strength,
		noise.get_noise_2d(100, _noise_i) * _shake_strength
	)


func _enable_buttons() -> void:
	pause.enable_buttons()


func _start_new_game() -> void:
	_game_paused = false
	
	_handle_pause_state()
	_reset_game_state()
	
	_game_started = true


func _reset_game_state() -> void:
	rand.randomize()
	noise.seed = randi()
	_background_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	_background_hue = randf()
	
	player.set_process(true)
	
	# Clear any bullets or enemies from an existing game
	Globals.remove_child_nodes(projectiles)
	Globals.remove_child_nodes(enemies)
	Waves.reset_enemies_defeated_combo()
	player.reset_player()
	stats.reset_points_and_stat_labels()
	stats.hide()
	_reset_stats()
	wave_start_timer.start()
	
	_wave = INITIAL_WAVE
	_score = 0
	_score_multiplier = 1
	_special_charges = 1
	_shake_decay_rate = SHAKE_DECAY_RATE_DEFAULT


func _restart_game() -> void:
	pause.continue_button.hide()
	pause.display_highscores()
	
	_game_paused = true
	
	_handle_pause_state()


func _enemy_defeated_screen_shake(enemy_type: String) -> void:
	if enemy_type == "Boss":
		_shake_decay_rate = SHAKE_DECAY_RATE_BOSS
		_apply_noise_shake(SHAKE_STRENGTH_BOSS + randf_range(-1.0, 1.0))
	else:
		_shake_decay_rate = SHAKE_DECAY_RATE_DEFAULT
		_apply_noise_shake(SHAKE_STRENGTH_DEFAULT + randf_range(-1.0, 1.0))


func _fade_out_on_death() -> void:
	_shake_decay_rate = SHAKE_DECAY_RATE_PLAYER
	
	_apply_noise_shake(SHAKE_STRENGTH_PLAYER)
	fade_out.show()
	fade_out.start_animation()


func _show_game_over_screen() -> void:
	Globals.remove_child_nodes(projectiles)
	Globals.remove_child_nodes(enemies)
	Input.set_custom_mouse_cursor(_cursor_arrow, Input.CURSOR_ARROW, Vector2(0, 0))
	
	_game_started = false
	game_over.show()
	game_over.set_enemies_defeated(Waves.get_enemies_defeated())
	game_over.set_total_score(_score)


func _start_wave() -> void:
	_wave += 1
	
	stats.set_wave_text(_wave + 1)
	Waves.set_enemies_in_wave(_wave)
	
	var wave_composition = Waves.get_wave_composition(_wave)
	var wave_count: int = Waves.get_wave_count()
	
	for group in wave_composition:
		var node_spawner_instance := _node_spawner_scene.instantiate() as NodeSpawner
		var group_config = group
		
		# Increase difficulty of final wave over time
		if _wave > wave_count:
			var increment: int = clampi(_wave - wave_count, 0, MAX_FINAL_WAVE_CHANGES)
			
			group_config.nodes_to_spawn += _final_wave_changes["nodes_to_spawn"] * increment
			group_config.node_health += _final_wave_changes["node_health"] * increment
			group_config.node_speed += _final_wave_changes["node_speed"] * increment
			group_config.node_speed_variance += _final_wave_changes["node_speed_variance"] * increment
			group_config.spawn_delay += _final_wave_changes["spawn_delay"] * increment
			group_config.start_delay += _final_wave_changes["start_delay"] * increment
			
			group_config.spawn_delay = clampf(group_config.spawn_delay, SPAWN_DELAY_MIN, 999)
			group_config.start_delay = clampf(group_config.start_delay, START_DELAY_MIN, 999)
		
		node_spawner_instance.configuration = group_config
		
		enemies.add_child(node_spawner_instance)


func _wave_end() -> void:
	if _wave > Waves.get_wave_count():
		wave_start_timer.start()
		return
	
	wave_end_timer.start()


func _show_stats_screen() -> void:
	Input.set_custom_mouse_cursor(_cursor_arrow, Input.CURSOR_ARROW, Vector2(0, 0))
	# Remove any stray bullets so they don't threaten the player
	for node in enemies.get_children():
		if node.has_method("explode"):
			node.explode()
		
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
		Input.set_custom_mouse_cursor(_cursor_arrow, Input.CURSOR_ARROW, Vector2(0, 0))
	else:
		pause.hide()
		pause.close_modals()
		
		if not stats.visible:
			Input.set_custom_mouse_cursor(_cursor_crosshair, Input.CURSOR_ARROW, Vector2(24, 24))


func _on_close_stats_screen() -> void:
	player.set_process(true)
	Input.set_custom_mouse_cursor(_cursor_crosshair, Input.CURSOR_ARROW, Vector2(24, 24))
	wave_start_timer.start()


func _increase_score(value: int, increase_multiplier: bool) -> void:
	_score += floori(value * _score_multiplier)
	
	if increase_multiplier and _score_multiplier < MAX_SCORE_MULTIPLIER:
		_score_multiplier += 1


func _reset_multiplier() -> void:
	_score_multiplier = 1


func _increase_special_charge() -> void:
	if _special_charges < MAX_SPECIAL_CHARGES:
		_special_charges += 1


func _update_player_health_bar(hp: int, max_hp: int) -> void:
	player_health_bar.update_health_bar(hp, max_hp)


func _update_player_special_bar(value: int, max_value: int) -> void:
	if _special_charges < MAX_SPECIAL_CHARGES:
		player_special_bar.update_special_bar(value, max_value)


func _on_fire_bullet(pos: Vector2, direction: Vector2) -> void:
	var bullet_instance := _player_bullet_scene.instantiate() as PlayerBullet
	
	if _spread_range > 0:
		_spread = randf_range(-_spread_range, _spread_range)
	
	var new_direction: Vector2 = direction.rotated(_spread)
	
	# Orientation
	bullet_instance.global_position = pos
	bullet_instance.direction = new_direction
	bullet_instance.rotation = new_direction.angle()
	
	# Stats
	bullet_instance.power = _bullet_power
	bullet_instance.pierce_count = _bullet_pierce_count
	bullet_instance.pierce_chance = _bullet_pierce_chance
	bullet_instance.speed_multiplier = _bullet_speed_multiplier
	
	projectiles.add_child(bullet_instance)


func _on_special_fired(pos: Vector2) -> void:
	if _special_charges > 0:
		var special_attack_instance := _special_attack_scene.instantiate() as SpecialAttack
		
		special_attack_instance.global_position = pos
		
		projectiles.add_child(special_attack_instance)
		
		_special_charges -= 1


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

