class_name EnemyFishChaser
extends Enemy


@export var hold_range: float = 175
@export var fire_range: float = 500
@export var fire_rate_time: float = 1.25
@export var fire_rate_variance: float = 0.8

@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_rate: Timer = $FireRate
@onready var _original_speed: float = speed


func _ready() -> void:
	super._ready()
	animation_player.play("boiling")
	_on_fire_rate_timeout()


func _process(delta):
	if global_position.distance_to(Globals.player_position) <= hold_range:
		speed = 0
	else:
		speed = _original_speed
	
	look_at(Globals.player_position)
	
	direction = _direction_to_player()
	
	super._process(delta)
	
	# Flip sprite vertically if facing left to keep it upright
	if direction.x < 0:
		enemy_sprite.flip_v = true
		enemy_sprite.offset.y = -3
	else:
		enemy_sprite.flip_v = false
		enemy_sprite.offset.y = 0


func _on_fire_rate_timeout() -> void:
	if global_position.distance_to(Globals.player_position) > fire_range:
		return
	
	fire_rate.wait_time = fire_rate_time + randf_range(0, fire_rate_variance)
	
	var enemy_bullet_instance := _enemy_bullet_scene.instantiate() as EnemyBullet
	enemy_bullet_instance.position = self.position
	enemy_bullet_instance.direction = _direction_to_player()
	
	add_sibling(enemy_bullet_instance)
