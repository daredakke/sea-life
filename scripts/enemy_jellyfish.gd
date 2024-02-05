class_name EnemyJellyfish
extends Enemy


const ARC: int = 360

@export var bullet_count: int = 8
@export var salvo_count: int = 3
@export var bullet_speed: float = 110

var _enemy_bullet_scene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super._ready()
	animation_player.play("boiling")


func _process(delta: float) -> void:
	super._process(delta)


func _die(score) -> void:
	for i in range(salvo_count):
		call_deferred("_fire_bullet_ring", i * 1)
		
	super._die(score)


func _fire_bullet_ring(speed_multiplier: float) -> void:
	for i in range(bullet_count):
		var bullet_instance := _enemy_bullet_scene.instantiate() as EnemyBullet
		bullet_instance.global_position = global_position
		bullet_instance.speed = bullet_speed
		bullet_instance.speed_multiplier = 1.0 + (speed_multiplier * 0.2)
		
		var dir = Vector2.RIGHT.rotated(deg_to_rad((ARC / bullet_count) * i))
		bullet_instance.direction = dir

		add_sibling(bullet_instance)
