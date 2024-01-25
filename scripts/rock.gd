class_name Rock
extends Enemy

var rotation_speed: float = randf_range(0.2, 0.8)
# false -> clockwise
var reverse_rotation: bool = false


func _ready() -> void:
	super._ready()
	rotation_degrees = randf_range(0, 360)
	
	if reverse_rotation:
		rotation_speed = -rotation_speed


func _process(delta):
	super._process(delta)
	self.rotation += rotation_speed * delta
