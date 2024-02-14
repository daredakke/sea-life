class_name Splash
extends Control


signal splash_ended

@export var bypass_splash: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var splash_timer: Timer = $SplashTimer


func _ready() -> void:
	self.show()
	animation_player.play("boiling")
	
	if bypass_splash:
		splash_timer.wait_time = 0.01
	
	splash_timer.start()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_end_splash()


func _end_splash() -> void:
	splash_ended.emit()
	self.queue_free()
