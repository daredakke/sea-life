extends Node


signal wave_over
signal score_increased(value: int, increase_multiplier: bool)
signal special_increased(value: int, max_value: int)
signal special_charged
signal shake_screen(enemy_type: String)

const MAX_ENEMY_DEFEATED_MILESTONE: int = 125

var can_increase_enemy_defeated_combo: bool = false

var _enemies_defeated_milestone: int = 50
var _enemies_in_wave: int = -1 
# For detecting if a wave is over
var _enemies_defeated_this_wave: int = 0
# For detecting if the player should get an extra special charge
var _enemies_defeated_combo: int = 0:
	set(new_value):
		if can_increase_enemy_defeated_combo:
			_enemies_defeated_combo = new_value
			special_increased.emit(new_value, _enemies_defeated_milestone)
# For display on the game over screen
var _enemies_defeated: int = 0
var _waves_collection: WavesCollection = preload("res://resources/waves_default.tres")
#var _waves_collection: WavesCollection = preload("res://resources/waves_test.tres")
# Once out of waves, this one will run on repeat with increasing difficulty
var _final_wave: WaveComposition = preload("res://resources/waves/final_wave.tres")


func get_wave_composition(wave: int) -> Array:
	if wave > get_wave_count() - 1:
		return _final_wave.composition
	
	return _waves_collection.collection[wave].composition


func set_enemies_in_wave(wave: int) -> void:
	_enemies_in_wave = 0
	_enemies_defeated_this_wave = 0
	
	var wave_composition: Array = get_wave_composition(wave)
	
	for group in wave_composition:
		_enemies_in_wave += group.nodes_to_spawn


func enemy_defeated(score_value: int, enemy_type: String) -> void:
	_enemies_defeated_this_wave += 1
	_enemies_defeated += 1
	
	if score_value > 0:
		_player_killed_enemy(score_value, enemy_type)
	
	if _enemies_defeated_this_wave >= _enemies_in_wave:
		wave_over.emit()


# Children of enemies do not count towards wave completion
func enemy_child_defeated(score_value: int, enemy_type: String) -> void:
	if score_value > 0:
		_player_killed_enemy(score_value, enemy_type)


func _player_killed_enemy(score_value: int, enemy_type: String) -> void:
	_enemies_defeated_combo += 1
		
	if _enemies_defeated_combo >= _enemies_defeated_milestone:
		_enemies_defeated_combo = -1
		
		if _enemies_defeated_milestone < MAX_ENEMY_DEFEATED_MILESTONE:
			_enemies_defeated_milestone += 1
		
		special_charged.emit()
	
	shake_screen.emit(enemy_type)
	score_increased.emit(score_value, true)


func reset_enemies_defeated_combo() -> void:
	_enemies_defeated_combo = 0


func get_wave_count() -> int:
	return _waves_collection.collection.size()


func get_enemies_defeated() -> int:
	return _enemies_defeated
