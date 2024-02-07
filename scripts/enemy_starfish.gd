class_name EnemyStarfish
extends Enemy


@export var fire_rate: float = 0.25
@export var reload_delay: float = 4.5
@export var shots_to_fire: int = 3

var _rotation_speed: float = randf_range(0.3, 0.6)
var _original_speed: float = speed
var _reduced_speed: float = speed * 0.25
var _weight: float = 0.0
var _shots_fired: int = 0
var _bullets_per_salvo: int = 4
var _enemy_bullet_scene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var reload_timer: Timer = $ReloadTimer


func _ready() -> void:
	super._ready()
	
	animation_player.play("boiling")
	fire_rate_timer.wait_time = fire_rate
	reload_timer.wait_time = reload_delay
	rotation_degrees = randf_range(0, 360)
	
	if randf() > 0.5:
		_rotation_speed = -_rotation_speed


func _process(delta):
	super._process(delta)
	rotation += _rotation_speed * delta
	
	# Cause station to decelerate after spawn
	if speed > _reduced_speed:
		speed = lerpf(_original_speed, _reduced_speed, _weight)
		
		_weight += 0.002


func _on_reload_timer_timeout() -> void:
	fire_rate_timer.start()


func _on_fire_rate_timer_timeout() -> void:
	if _shots_fired >= shots_to_fire:
		_shots_fired = 0
		reload_timer.start()
		return
	
	for i in range(_bullets_per_salvo):
		var bullet_instance := _enemy_bullet_scene.instantiate() as EnemyBullet
		bullet_instance.position = self.position
		bullet_instance.direction = self.direction.rotated(self.rotation + deg_to_rad(90) * i)
		add_sibling(bullet_instance)
	
	_shots_fired += 1
	fire_rate_timer.start()
