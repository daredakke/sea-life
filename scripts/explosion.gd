class_name Explosion
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("fade_out")


func _on_animation_finished(anim_name: StringName) -> void:
	queue_free()
