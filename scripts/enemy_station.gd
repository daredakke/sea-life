class_name EnemyStation
extends Enemy


var _rotation_speed: float = randf_range(0.3, 0.6)
var _original_speed: float = speed
var _reduced_speed: float = speed * 0.25
var _weight: float = 0.0


func _ready() -> void:
	super._ready()
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
