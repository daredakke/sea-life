class_name EnemyFishKamikaze
extends Enemy


@export var bullet_speed: int = 75
@export var salvo_size: int = 8

var _decel_rate: float = 0.2

@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_timer: Timer = $DeathTimer


func _ready() -> void:
	super._ready()
	animation_player.play("boiling")
	
	# Flip sprite vertically if facing left to keep it upright
	if direction.x < 0:
		enemy_sprite.flip_v = true
		enemy_sprite.offset.y = 7
	else:
		enemy_sprite.flip_v = false
		enemy_sprite.offset.y = 0
	
	rotation = direction.angle()


func _process(delta: float) -> void:
	if speed < 1:
		if death_timer.is_stopped():
			death_timer.start()
		
		return
	
	speed -= _decel_rate
	
	super._process(delta)


func _on_death_timer_timeout() -> void:
	for i in range(salvo_size):
		var enemy_bullet_instance := _enemy_bullet_scene.instantiate() as EnemyBullet
		enemy_bullet_instance.position = self.position
		enemy_bullet_instance.speed = bullet_speed
		enemy_bullet_instance.direction = Vector2.RIGHT.rotated(TAU * (randf() + i + 1))
		
		add_sibling(enemy_bullet_instance)
	
	_die(0)
