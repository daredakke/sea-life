class_name Player
extends CharacterBody2D

signal fire_bullet(pos: Vector2, direction: Vector2)

const ANGULAR_SPEED: float = TAU * 2

@onready var bullet_spawn_timer: Timer = %BulletSpawnTimer
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint

@export var player_speed: float = 500

var fire_rate: float = 0.33
var player_direction: Vector2
var target_angle: float


func _ready() -> void:
	look_at(get_global_mouse_position())
	
	bullet_spawn_timer.wait_time = fire_rate


func _process(delta):
	# Movement
	var direction := Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * player_speed
	move_and_slide()
	
	# Rotation
	target_angle = (get_global_mouse_position() - position).angle()
	var angle_diff: float = wrapf(target_angle - rotation, -PI, PI)
	rotation += clamp(ANGULAR_SPEED * delta, 0, abs(angle_diff)) * sign(angle_diff)
	
	if Input.is_action_pressed("fire") and bullet_spawn_timer.is_stopped():
		var player_direction = (get_global_mouse_position() - position).normalized()
		fire_bullet.emit(bullet_spawn_point.global_position, player_direction)
		bullet_spawn_timer.start()


func set_fire_rate(multiplier: int) -> void:
	fire_rate = fire_rate * (1.1 - (multiplier * 0.1))
