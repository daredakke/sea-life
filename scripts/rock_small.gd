class_name RockSmall
extends Rock


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta):
	super._process(delta)
	animation_player.play("boiling")
