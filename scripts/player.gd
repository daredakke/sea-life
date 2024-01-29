class_name Player
extends CharacterBody2D


signal fire_bullet(pos: Vector2, direction: Vector2)
signal player_position(pos: Vector2)

const ANGULAR_SPEED: float = TAU * 2

@export var player_speed: float = 500
@export var shields: float = 100

var is_alive: bool = true
var player_direction: Vector2
var fire_rate: float = 0.33

var _target_angle: float
var _dead_position := Vector2(-1000, -1000)

@onready var bullet_spawn_timer: Timer = %BulletSpawnTimer
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint


func _ready() -> void:
	look_at(get_global_mouse_position())
	
	bullet_spawn_timer.wait_time = fire_rate


func _process(delta):
	if not is_alive:
		return
	
	player_position.emit(global_position)
	
	# Movement
	var direction := Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * player_speed
	move_and_slide()
	
	# Rotation
	_target_angle = (get_global_mouse_position() - position).angle()
	var angle_diff: float = wrapf(_target_angle - rotation, -PI, PI)
	rotation += clamp(ANGULAR_SPEED * delta, 0, abs(angle_diff)) * sign(angle_diff)
	
	if Input.is_action_pressed("fire") and bullet_spawn_timer.is_stopped():
		var player_dir: Vector2 = (get_global_mouse_position() - position).normalized()
		
		fire_bullet.emit(bullet_spawn_point.global_position, player_dir)
		bullet_spawn_timer.start()


func set_fire_rate(multiplier: int) -> void:
	bullet_spawn_timer.wait_time = fire_rate * (1.1 - (multiplier * 0.1))


func kill_player() -> void:
	is_alive = false
	global_position = _dead_position


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_bullet"):
		shields -= area.power
