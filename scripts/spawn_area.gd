class_name SpawnArea
extends Node2D

@export_enum("Horizontal", "Vertical") var orientation: int
@export var start: float = 0
@export var end: float = 100


func get_random_spawn_position() -> Vector2:
	if orientation:
		return get_random_y_position()
	else:
		return get_random_x_position()


func get_random_x_position() -> Vector2:
	var random_x: float = randf_range(start, end)
	
	return Vector2(random_x, self.global_position.y)


func get_random_y_position() -> Vector2:
	var random_y: float = randf_range(start, end)
	
	return Vector2(self.global_position.x, random_y)
