class_name SpecialAttack
extends Area2D


@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("fade_out")


func _process(_delta: float) -> void:
	global_position = Globals.player_position


func _on_animation_finished(_anim_name: StringName) -> void:
	self.queue_free()


func _on_effect_timer_timeout() -> void:
	collision_shape.queue_free()
