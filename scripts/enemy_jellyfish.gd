class_name EnemyJellyfish
extends Enemy


const BULLET_COUNT: int = 8
const ARC: int = 360

@export var fire_rate: float = 1.0

var _enemy_bullet_scene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_rate_timer: Timer = $FireRate
@onready var start_delay: Timer = $StartDelay


func _ready() -> void:
	super._ready()
	animation_player.play("boiling")


func _process(delta: float) -> void:
	super._process(delta)


func _on_start_delay_timeout() -> void:
	fire_rate_timer.start()


func _on_fire_rate_timeout() -> void:
	for i in range(BULLET_COUNT):
		var bullet_instance := _enemy_bullet_scene.instantiate() as Area2D
		bullet_instance.global_position = global_position
		
		var dir = Vector2.RIGHT.rotated(deg_to_rad((ARC / BULLET_COUNT) * i))
		bullet_instance.direction = dir

		add_sibling(bullet_instance)
