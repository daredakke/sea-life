class_name Explosion
extends Sprite2D


@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_animation_player.play("fade_out")


func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
