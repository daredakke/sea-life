class_name BossNautilus
extends Enemy


const ANGULAR_SPEED: float = TAU * 0.08
const ARC: float = 360.0

@export var final_speed: float = 30

var _decel_rate: float = 0.2
var _target_angle: float
var _bullets_in_burst: int = 50
var _bullets_in_ring: int = 40

@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shell_collision: CollisionShape2D = $ShellCollision
@onready var body_collision_1: CollisionShape2D = $BodyCollision1
@onready var body_collision_2: CollisionShape2D = $BodyCollision2
@onready var start_timer: Timer = $StartTimer
@onready var burst_timer: Timer = $BurstTimer
@onready var ring_timer: Timer = $RingTimer


func _ready() -> void:
	super._ready()
	animation_player.play("boiling")
	look_at(Globals.player_position)
	direction = _direction_to_player()


func _process(delta: float) -> void:
	if speed > final_speed:
		speed -= _decel_rate
	
	# Rotation
	_target_angle = (Globals.player_position - position).angle()
	var angle_diff: float = wrapf(_target_angle - rotation, -PI, PI)
	rotation += clamp(ANGULAR_SPEED * delta, 0, abs(angle_diff)) * sign(angle_diff)
	
	direction = Vector2.RIGHT.rotated(rotation)
	
	super._process(delta)
	
	# Flip sprite vertically if facing left to keep it upright
	if direction.x < 0:
		enemy_sprite.flip_v = true
		shell_collision.position.y = -shell_collision.position.y
		body_collision_1.position.y = -body_collision_1.position.y
		body_collision_2.position.y = -body_collision_2.position.y
	else:
		enemy_sprite.flip_v = false
		shell_collision.position.y = abs(shell_collision.position.y)
		body_collision_1.position.y = abs(body_collision_1.position.y)
		body_collision_2.position.y = abs(body_collision_2.position.y)


func _on_start_timer_timeout() -> void:
	ring_timer.start()


func _on_ring_timer_timeout() -> void:
	for i in _bullets_in_ring:
		var bullet_instance := _enemy_bullet_scene.instantiate() as EnemyBullet
		var segments := deg_to_rad(ARC / _bullets_in_ring)
		bullet_instance.position = position
		bullet_instance.direction = direction.rotated(rotation + segments * i)
		bullet_instance.speed = 100
		
		add_sibling(bullet_instance)


func _on_burst_timer_timeout() -> void:
	for i in _bullets_in_burst:
		var bullet_instance := _enemy_bullet_scene.instantiate() as EnemyBullet
		bullet_instance.position = position
		bullet_instance.direction = direction.rotated(deg_to_rad(90 * i + (2 * i)))
		bullet_instance.speed = 50 + (1 * i)
		
		add_sibling(bullet_instance)
