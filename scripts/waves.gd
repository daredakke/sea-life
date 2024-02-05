extends Node


signal wave_over
signal score_increased(value: int, increase_multiplier: bool)
signal special_charged

const ENEMIES_DEFEATED_MILESTONE: int = 50

var _enemies_in_wave: int = -1 
# For detecting if a wave is over
var _enemies_defeated_this_wave: int = 0
# For detecting if the player should get an extra special charge
var _enemies_defeated_combo: int = 0
# For display on the game over screen
var _enemies_defeated: int = 0:
	set(new_value):
		_enemies_defeated = new_value
		
		if _enemies_defeated_combo >= ENEMIES_DEFEATED_MILESTONE + _wave_data.size():
			_enemies_defeated_combo = 0
			
			special_charged.emit()
var _rock_small_scene: PackedScene = preload("res://scenes/enemies/rock_small.tscn")
var _rock_large_scene: PackedScene = preload("res://scenes/enemies/rock_large.tscn")
var _enemy_ship_scene: PackedScene = preload("res://scenes/enemies/enemy_ship.tscn")
var _enemy_station_scene: PackedScene = preload("res://scenes/enemies/enemy_station.tscn")
var _enemy_crab_scene: PackedScene = preload("res://scenes/enemies/enemy_crab.tscn")
var _enemy_jellyfish_scene: PackedScene = preload("res://scenes/enemies/enemy_jellyfish.tscn")
var _wave_data: Dictionary = {
	1: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 120,
			"node_speed": 100,
			"node_speed_variance": 30,
			"spawn_delay": 0.05,
			"aim_at_player": false,
		},
	],
	
	2: [
		{
			"node_scene": _enemy_crab_scene,
			"nodes_to_spawn": 12,
			"node_speed": 70,
			"node_speed_variance": 30,
			"spawn_delay": 2,
			"aim_at_player": false,
		},
	],
	
	3: [
		{
			"node_scene": _enemy_crab_scene,
			"nodes_to_spawn": 6,
			"node_speed": 80,
			"node_speed_variance": 50,
			"spawn_delay": 3,
			"aim_at_player": true,
		},
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 10,
			"node_speed": 60,
			"node_speed_variance": 45,
			"spawn_delay": 1.9,
			"aim_at_player": false,
		},
	],
	
	4: [
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 10,
			"node_speed": 70,
			"node_speed_variance": 50,
			"spawn_delay": 2.2,
			"aim_at_player": true,
		},
	],
	
	5: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 14,
			"node_speed": 75,
			"node_speed_variance": 40,
			"spawn_delay": 0.8,
			"aim_at_player": true,
		},
		{
			"node_scene": _rock_large_scene,
			"nodes_to_spawn": 8,
			"node_speed": 55,
			"node_speed_variance": 25,
			"spawn_delay": 1.3,
			"aim_at_player": false,
		},
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 12,
			"node_speed": 70,
			"node_speed_variance": 50,
			"start_delay": 11,
			"spawn_delay": 2.3,
			"aim_at_player": true,
		},
	],
	
	6: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 10,
			"node_speed": 80,
			"node_speed_variance": 60,
			"spawn_delay": 0.1,
			"aim_at_player": true,
		},
		{
			"node_scene": _enemy_crab_scene,
			"nodes_to_spawn": 8,
			"node_speed": 70,
			"node_speed_variance": 40,
			"start_delay": 5,
			"spawn_delay": 1.5,
			"aim_at_player": false,
		},
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 8,
			"node_speed": 70,
			"node_speed_variance": 40,
			"start_delay": 6.5,
			"spawn_delay": 1.5,
			"aim_at_player": true,
		},
	],
	
	7: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 50,
			"node_speed": 120,
			"node_speed_variance": 50,
			"spawn_delay": 0.2,
			"aim_at_player": true,
		},
		{
			"node_scene": _rock_large_scene,
			"nodes_to_spawn": 20,
			"node_speed": 100,
			"node_speed_variance": 40,
			"spawn_delay": 0.5,
			"aim_at_player": true,
		},
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 40,
			"node_speed": 90,
			"node_speed_variance": 100,
			"start_delay": 10,
			"spawn_delay": 1,
			"aim_at_player": true,
		},
		{
			"node_scene": _enemy_station_scene,
			"nodes_to_spawn": 20,
			"node_speed": 80,
			"node_speed_variance": 35,
			"start_delay": 15,
			"spawn_delay": 2,
			"aim_at_player": true,
		},
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 50,
			"node_speed": 140,
			"node_speed_variance": 50,
			"start_delay": 20,
			"spawn_delay": 0.05,
			"aim_at_player": true,
		},
	],
}


func get_wave_parameters(wave: int) -> Array:
	var index = clampi(wave, 1, _wave_data.size())
	
	return _wave_data[index]


func set_enemies_in_wave(wave: int) -> void:
	var index = clampi(wave, 1, _wave_data.size())
	
	_enemies_in_wave = 0
	_enemies_defeated_this_wave = 0
	
	for params in _wave_data[index]:
		_enemies_in_wave += params["nodes_to_spawn"]


func enemy_defeated(score_value: int) -> void:
	_enemies_defeated_this_wave += 1
	_enemies_defeated += 1
	_enemies_defeated_combo += 1
	
	if score_value > 0:
		score_increased.emit(score_value, true)
	
	if _enemies_defeated_this_wave >= _enemies_in_wave:
		wave_over.emit()


func get_wave_count() -> int:
	return _wave_data.size()


func get_enemies_defeated() -> int:
	return _enemies_defeated
