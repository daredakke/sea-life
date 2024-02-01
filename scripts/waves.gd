extends Node


signal wave_over
signal score_increased(value: int, increase_multiplier: bool)

var _enemies_in_wave: int = -1
var _enemies_defeated_this_wave: int = 0
var _enemies_defeated: int = 0
var _rock_small_scene: PackedScene = preload("res://scenes/enemies/rock_small.tscn")
var _rock_large_scene: PackedScene = preload("res://scenes/enemies/rock_large.tscn")
var _enemy_ship_scene: PackedScene = preload("res://scenes/enemies/enemy_ship.tscn")
var _enemy_station_scene: PackedScene = preload("res://scenes/enemies/enemy_station.tscn")
var _wave_data: Dictionary = {
	1: [
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 10,
			"node_speed": 80,
			"node_speed_variance": 30,
			"spawn_delay": 2.1,
			"aim_at_player": false,
		},
	],
	
	2: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 10,
			"node_speed": 85,
			"node_speed_variance": 35,
			"spawn_delay": 2.1,
			"aim_at_player": false,
		},
		{
			"node_scene": _rock_large_scene,
			"nodes_to_spawn": 5,
			"node_speed": 65,
			"node_speed_variance": 25,
			"start_delay": 7,
			"spawn_delay": 3,
			"aim_at_player": false,
		},
	],
	
	3: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 10,
			"node_speed": 100,
			"node_speed_variance": 40,
			"spawn_delay": 2,
			"aim_at_player": false,
		},
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 10,
			"node_speed": 90,
			"node_speed_variance": 50,
			"start_delay": 14,
			"spawn_delay": 0.2,
			"aim_at_player": true,
		},
	],
	
	4: [
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
	
	if score_value > 0:
		score_increased.emit(score_value, true)
	
	if _enemies_defeated_this_wave >= _enemies_in_wave:
		wave_over.emit()


func get_wave_count() -> int:
	return _wave_data.size()


func get_enemies_defeated() -> int:
	return _enemies_defeated
