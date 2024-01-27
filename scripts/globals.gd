extends Node

var player_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_player_position(pos: Vector2) -> void:
	player_position = pos
