class_name EnemyStation
extends Enemy


var _rotation_speed: float = randf_range(0.3, 0.6)


func _ready() -> void:
	super._ready()
	rotation_degrees = randf_range(0, 360)
	
	if randf() > 0.5:
		_rotation_speed = -_rotation_speed


func _process(delta):
	super._process(delta)
	rotation += _rotation_speed * delta
