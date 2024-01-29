class_name Pause
extends Control


signal toggle_fullscreen(state: bool)
signal change_music_volume(value: float)
signal change_sfx_volume(value: float)

var _is_fullscreen: bool = false

@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var quit_button: Button = %QuitButton
@onready var music_label: Label = %MusicLabel
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_label: Label = %SFXLabel
@onready var sfx_slider: HSlider = %SFXSlider
@onready var resolution_button: Button = %ResolutionButton
@onready var music_volume_change_timer: Timer = %MusicVolumeChangeTimer
@onready var sfx_volume_change_timer: Timer = %SFXVolumeChangeTimer


func _ready() -> void:
	continue_button.hide()


func _on_music_slider_value_changed(_value: float) -> void:
	if music_volume_change_timer.is_stopped():
		music_volume_change_timer.start()


func _on_sfx_slider_value_changed(_value: float) -> void:
	if sfx_volume_change_timer.is_stopped():
		sfx_volume_change_timer.start()


func _on_music_volume_change_timer_timeout() -> void:
	music_label.text = "MUSIC - " + str(music_slider.value) + "%"
	self.change_music_volume.emit(music_slider.value)


func _on_sfx_volume_change_timer_timeout() -> void:
	sfx_label.text = "SFX - " + str(sfx_slider.value) + "%"
	self.change_sfx_volume.emit(sfx_slider.value)


func _on_resolution_button_pressed() -> void:
	_is_fullscreen = !_is_fullscreen
	
	if _is_fullscreen:
		resolution_button.text = "WINDOWED"
	else:
		resolution_button.text = "FULLSCREEN"
	
	toggle_fullscreen.emit(_is_fullscreen)


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.


func _on_new_game_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
