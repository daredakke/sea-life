class_name RockLarge
extends Rock


var _spawn_count: int = 2
var _rock_small_scene: PackedScene = preload("res://scenes/enemies/rock_small.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("boiling")


func _die(score: int) -> void:
	# Spawn two small rocks in random directions on death
	for i in _spawn_count:
		var _rock_small_instance := _rock_small_scene.instantiate() as RockSmall
		_rock_small_instance.position = position
		_rock_small_instance.direction = direction.rotated(deg_to_rad(randf_range(-15, 15)))
		_rock_small_instance.speed = speed + randf() * 10
		
		call_deferred("add_sibling", _rock_small_instance)
	
	super._die(score)
