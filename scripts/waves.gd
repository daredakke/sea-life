extends Node


signal wave_over
signal score_increased(value: int, increase_multiplier: bool)
signal special_charged

var _enemies_defeated_milestone: int = 50
var _enemies_in_wave: int = -1 
# For detecting if a wave is over
var _enemies_defeated_this_wave: int = 0
# For detecting if the player should get an extra special charge
var _enemies_defeated_combo: int = 0
# For display on the game over screen
var _enemies_defeated: int = 0:
	set(new_value):
		_enemies_defeated = new_value
		
		if _enemies_defeated_combo >= _enemies_defeated_milestone:
			_enemies_defeated_combo = 0
			
			if _enemies_defeated_milestone < 100:
				_enemies_defeated_milestone += 1
			
			special_charged.emit()

var _waves_collection: WavesCollection = preload("res://resources/waves_default.tres")


func get_wave_composition(wave: int) -> Array:
	var index: int = clampi(wave, 0, get_wave_count() - 1)
	
	return _waves_collection.collection[index].composition


func set_enemies_in_wave(wave: int) -> void:
	_enemies_in_wave = 0
	_enemies_defeated_this_wave = 0
	
	var wave_composition: Array = get_wave_composition(wave)
	
	for group in wave_composition:
		_enemies_in_wave += group.nodes_to_spawn
	
	print("enemies in wave: " + str(_enemies_in_wave))


func enemy_defeated(score_value: int) -> void:
	_enemies_defeated_this_wave += 1
	_enemies_defeated += 1
	_enemies_defeated_combo += 1
	
	if score_value > 0:
		score_increased.emit(score_value, true)
	
	if _enemies_defeated_this_wave >= _enemies_in_wave:
		wave_over.emit()


func get_wave_count() -> int:
	return _waves_collection.collection.size()


func get_enemies_defeated() -> int:
	return _enemies_defeated
