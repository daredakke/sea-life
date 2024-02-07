class_name EnemySquid
extends Enemy


@export var bullet_speed: int = 40
@export var salvo_size: int = 3

var _decel_rate: float = 0.5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var _original_speed: float = speed
@onready var speed_reset_timer: Timer = $SpeedResetTimer
@onready var bullet_spawn: Marker2D = $BulletSpawnMarker
@onready var bullet_target: Marker2D = $BulletTargetMarker


func _ready() -> void:
	super._ready()
	animation_player.play("boiling")
	
	rotation = direction.angle()


func _process(delta: float) -> void:
	if speed > 1:
		speed -= _decel_rate
	
	super._process(delta)


func _on_speed_reset_timer_timeout() -> void:
	speed = _original_speed
	
	for i in range(salvo_size):
		var enemy_bullet_instance := _enemy_bullet_scene.instantiate() as EnemyBullet
		var rand_coord := Vector2(randf_range(-8, 8), randf_range(-8, 8))
		var target_x_pos: float = bullet_target.global_position.x + rand_coord.x
		var target_y_pos: float = bullet_target.global_position.y + rand_coord.y
		var target := Vector2(target_x_pos, target_y_pos)
		var bullet_direction := bullet_spawn.global_position.direction_to(target)
		
		enemy_bullet_instance.direction = bullet_direction
		enemy_bullet_instance.global_position = bullet_spawn.global_position
		enemy_bullet_instance.speed = bullet_speed
		
		add_sibling(enemy_bullet_instance)
