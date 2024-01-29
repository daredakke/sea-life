extends Node


signal wave_over

var _enemies_in_wave: int = -1
var _enemies_defeated: int = 0
var _rock_small_scene: PackedScene = preload("res://scenes/enemies/rock_small.tscn")
var _rock_large_scene: PackedScene = preload("res://scenes/enemies/rock_large.tscn")
var _enemy_ship_scene: PackedScene = preload("res://scenes/enemies/enemy_ship.tscn")
var _enemy_station_scene: PackedScene = preload("res://scenes/enemies/enemy_station.tscn")
var _wave_data: Dictionary = {
	1: [
		{
			"node_scene": _rock_small_scene,
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
			"nodes_to_spawn": 8,
			"node_speed": 85,
			"node_speed_variance": 35,
			"spawn_delay": 2.5,
			"aim_at_player": false,
		},
		{
			"node_scene": _rock_large_scene,
			"nodes_to_spawn": 5,
			"node_speed": 65,
			"node_speed_variance": 25,
			"spawn_delay": 3,
			"aim_at_player": false,
		},
	],
	
	3: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 12,
			"node_speed": 85,
			"node_speed_variance": 40,
			"spawn_delay": 2,
			"aim_at_player": false,
		},
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 8,
			"node_speed": 90,
			"node_speed_variance": 50,
			"spawn_delay": 3,
			"aim_at_player": true,
		},
	],
	
	4: [
		{
			"node_scene": _rock_small_scene,
			"nodes_to_spawn": 100,
			"node_speed": 85,
			"node_speed_variance": 40,
			"spawn_delay": 0.3,
			"aim_at_player": true,
		},
		{
			"node_scene": _rock_large_scene,
			"nodes_to_spawn": 45,
			"node_speed": 85,
			"node_speed_variance": 40,
			"spawn_delay": 1.7,
			"aim_at_player": true,
		},
		{
			"node_scene": _enemy_ship_scene,
			"nodes_to_spawn": 80,
			"node_speed": 90,
			"node_speed_variance": 50,
			"spawn_delay": 1.1,
			"aim_at_player": true,
		},
		{
			"node_scene": _enemy_station_scene,
			"nodes_to_spawn": 40,
			"node_speed": 80,
			"node_speed_variance": 30,
			"spawn_delay": 2,
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
	_enemies_defeated = 0
	
	for params in _wave_data[index]:
		_enemies_in_wave += params["nodes_to_spawn"]


func enemy_defeated() -> void:
	_enemies_defeated += 1
	
	if _enemies_defeated >= _enemies_in_wave:
		wave_over.emit()


func get_wave_count() -> int:
	return _wave_data.size()
