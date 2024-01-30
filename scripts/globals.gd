extends Node


var player_position: Vector2

@onready var score: int = 0


func update_player_position(pos: Vector2) -> void:
	player_position = pos
