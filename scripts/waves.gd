extends Node

signal wave_over

var rock_small_scene: PackedScene = preload("res://scenes/enemies/rock_small.tscn")
var rock_large_scene: PackedScene = preload("res://scenes/enemies/rock_large.tscn")
var enemy_ship_scene: PackedScene = preload("res://scenes/enemies/enemy_ship.tscn")

var enemies_in_wave: int = -1
var enemies_defeated: int = 0

var wave_data: Dictionary = {
	1: [
		{
			"node_scene": rock_small_scene,
			"nodes_to_spawn": 15,
			"node_speed": 80,
			"node_speed_variance": 30,
			"spawn_delay": 2,
			"aim_at_player": false,
		},
	],
	
	2: [
		{
			"node_scene": rock_small_scene,
			"nodes_to_spawn": 8,
			"node_speed": 80,
			"node_speed_variance": 35,
			"spawn_delay": 1.9,
			"aim_at_player": false,
		},
		{
			"node_scene": rock_large_scene,
			"nodes_to_spawn": 8,
			"node_speed": 65,
			"node_speed_variance": 25,
			"spawn_delay": 2,
			"aim_at_player": false,
		},
	],
	
	3: [
		{
			"node_scene": rock_small_scene,
			"nodes_to_spawn": 12,
			"node_speed": 80,
			"node_speed_variance": 35,
			"spawn_delay": 2,
			"aim_at_player": false,
		},
		{
			"node_scene": enemy_ship_scene,
			"nodes_to_spawn": 8,
			"node_speed": 90,
			"node_speed_variance": 50,
			"spawn_delay": 3,
			"aim_at_player": true,
		},
	],
}


func get_wave_parameters(wave: int) -> Array:
	var index = wave if wave < wave_data.size() else wave_data.size()
	
	return wave_data[index]


func set_enemies_in_wave(wave: int) -> void:
	enemies_in_wave = 0
	enemies_defeated = 0
	
	for params in wave_data[wave]:
		enemies_in_wave += params["nodes_to_spawn"]


func enemy_defeated() -> void:
	enemies_defeated += 1
