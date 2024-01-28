class_name EnemyShip
extends Enemy


@export var hold_range: float = 150
@export var fire_range: float = 700
@export var fire_rate_time: float = 1
@export var fire_rate_variance: float = 0.5

var _enemy_bullet_scene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")

@onready var fire_rate: Timer = $FireRate
@onready var _original_speed: float = speed


func _ready() -> void:
	super._ready()
	_on_fire_rate_timeout()


func _process(delta):
	if global_position.distance_to(Globals.player_position) <= hold_range:
		speed = 0
	else:
		speed = _original_speed
	
	super._process(delta)
	look_at(Globals.player_position)
	rotation_degrees += 90
	
	direction = _direction_to_player()


func _on_fire_rate_timeout() -> void:
	if global_position.distance_to(Globals.player_position) > fire_range:
		return
	
	fire_rate.wait_time = fire_rate_time + randf_range(0, fire_rate_variance)
	
	var enemy_bullet_instance := _enemy_bullet_scene.instantiate() as Area2D
	enemy_bullet_instance.position = self.position
	enemy_bullet_instance.direction = _direction_to_player()
	
	add_sibling(enemy_bullet_instance)


func _direction_to_player() -> Vector2:
	return global_position.direction_to(Globals.player_position)
