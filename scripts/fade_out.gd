class_name FadeOut
extends Control


signal animation_finished

@onready var color_rect: ColorRect = %ColorRect
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	self.hide()


func start_animation() -> void:
	self.show()
	animation_player.play("fade_out")


func _on_animation_finished(anim_name: StringName) -> void:
	self.hide()
	animation_finished.emit()
	animation_player.stop()
