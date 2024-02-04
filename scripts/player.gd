class_name Player
extends CharacterBody2D


signal fire_bullet(pos: Vector2, direction: Vector2)
signal special_fired(pos: Vector2)
signal player_position(pos: Vector2)
# For resetting score multiplier
signal player_hit
# For updating health bar UI
signal player_health_changed(value: int, max_health: int)
signal bullet_grazed(value: int, increase_multiplier: bool)
signal player_died

const ANGULAR_SPEED: float = TAU * 2
const MAX_HEALTH: float = 100
const ENEMY_DAMAGE: float = 40

@export var player_speed: float = 500
@export var health: float = MAX_HEALTH:
	set(new_value):
		health = clampf(new_value, -1, MAX_HEALTH)
		player_health_changed.emit(new_value, MAX_HEALTH)
@export var health_recovery_rate: float = 0.1
@export var bullet_graze_score: int = 30
@export var explosion_scale: float = 0.3

var is_alive: bool = true
var player_direction: Vector2
var fire_rate: float = 0.33

var _target_angle: float
var _dead_position := Vector2(-1000, -1000)
var _explosion_scene: PackedScene = preload("res://scenes/explosion.tscn")

@onready var hit_box_sprite: Sprite2D = %HitBoxSprite
@onready var health_recovery_timer: Timer = %HealthRecoveryTimer
@onready var bullet_spawn_timer: Timer = %BulletSpawnTimer
@onready var special_cooldown_timer: Timer = %SpecialCooldownTimer
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint


func _ready() -> void:
	look_at(get_global_mouse_position())
	
	health_recovery_timer.wait_time = health_recovery_rate
	bullet_spawn_timer.wait_time = fire_rate


func _process(delta):
	if not is_alive:
		return
	
	# Movement
	var move_speed: float
	
	if Input.is_action_pressed("focus"):
		move_speed = player_speed * 0.5
		hit_box_sprite.show()
	else:
		move_speed = player_speed
		hit_box_sprite.hide()
	
	var direction := Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * move_speed
	
	move_and_slide()
	player_position.emit(global_position)
	
	# Rotation
	_target_angle = (get_global_mouse_position() - position).angle()
	var angle_diff: float = wrapf(_target_angle - rotation, -PI, PI)
	rotation += clamp(ANGULAR_SPEED * delta, 0, abs(angle_diff)) * sign(angle_diff)
	
	if Input.is_action_pressed("fire") and bullet_spawn_timer.is_stopped():
		var player_dir: Vector2 = (get_global_mouse_position() - position).normalized()
		
		fire_bullet.emit(bullet_spawn_point.global_position, player_dir)
		bullet_spawn_timer.start()
	
	if Input.is_action_pressed("special") and special_cooldown_timer.is_stopped():
		special_fired.emit(global_position)
		special_cooldown_timer.start()


func set_fire_rate(multiplier: int) -> void:
	bullet_spawn_timer.wait_time = fire_rate * (1.1 - (multiplier * 0.1))


func kill_player() -> void:
	_spawn_explosion()
	
	is_alive = false
	global_position = _dead_position


func reset_player() -> void:
	is_alive = true
	global_position = Vector2(get_viewport().size.x * 0.5, get_viewport().size.y * 0.5)
	health = MAX_HEALTH


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		_take_damage(ENEMY_DAMAGE)
	
	if area.is_in_group("enemy_bullet"):
		_take_damage(area.power)
	
	if area.is_in_group("graze_area"):
		bullet_grazed.emit(bullet_graze_score, false)


func _take_damage(value: int) -> void:
	health -= value
	
	player_hit.emit()


func _on_health_recovery_timer_timeout() -> void:
	if is_alive and health < MAX_HEALTH:
		health += 1


func _on_player_health_changed(value: int, _max_health: int) -> void:
	if value <= 0:
		kill_player()
		player_died.emit()


func _spawn_explosion() -> void:
	var explosion_instance = _explosion_scene.instantiate()
	explosion_instance.global_position = global_position
	explosion_instance.animation_speed_scale = 0.5
	explosion_instance.scale = Vector2(explosion_scale, explosion_scale)
	
	add_sibling(explosion_instance)
