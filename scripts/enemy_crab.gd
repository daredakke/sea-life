class_name EnemyCrab
extends Enemy


var _decel_rate: float = 0.2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var _original_speed: float = speed
@onready var speed_reset_timer: Timer = $SpeedResetTimer


func _ready() -> void:
	super._ready()
	animation_player.play("boiling")
	
	look_at(Globals.player_position)
	direction = _direction_to_player()


func _process(delta: float) -> void:
	if speed > 1:
		speed -= _decel_rate
	
	super._process(delta)


func _on_speed_reset_timer_timeout() -> void:
	speed = _original_speed
	direction = _direction_to_player()
	look_at(Globals.player_position)
