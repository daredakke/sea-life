class_name Player
extends CharacterBody2D

const ANGULAR_SPEED: float = TAU * 2

@export var player_speed: float = 500

var player_direction: Vector2
var target_angle: float


func _ready() -> void:
	look_at(get_global_mouse_position())


func _process(delta):
	# Movement
	var direction := Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * player_speed
	move_and_slide()
	
	# Rotation
	target_angle = (get_global_mouse_position() - position).angle()
	var angle_diff: float = wrapf(target_angle - rotation, -PI, PI)
	rotation += clamp(ANGULAR_SPEED * delta, 0, abs(angle_diff)) * sign(angle_diff)
