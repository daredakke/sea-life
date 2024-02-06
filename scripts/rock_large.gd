class_name RockLarge
extends Rock


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("boiling")
