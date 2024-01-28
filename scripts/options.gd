class_name Options
extends Control


signal toggle_fullscreen(state: bool)
signal change_music_volume(value: float)
signal change_sfx_volume(value: float)

var _is_fullscreen: bool = false

@onready var _music_label: Label = %MusicLabel
@onready var _music_slider: HSlider = %MusicSlider
@onready var _sfx_label: Label = %SFXLabel
@onready var _sfx_slider: HSlider = %SFXSlider
@onready var _music_volume_change_timer: Timer = %MusicVolumeChangeTimer
@onready var _sfx_volume_change_timer: Timer = %SFXVolumeChangeTimer
@onready var _resolution_button: Button = %ResolutionButton


func _ready() -> void:
	self.hide()


func _on_music_slider_value_changed(_value: float) -> void:
	if _music_volume_change_timer.is_stopped():
		_music_volume_change_timer.start()


func _on_sfx_slider_value_changed(_value: float) -> void:
	if _sfx_volume_change_timer.is_stopped():
		_sfx_volume_change_timer.start()


func _on_music_volume_change_timer_timeout() -> void:
	_music_label.text = "MUSIC - " + str(_music_slider.value) + "%"
	self.change_music_volume.emit(_music_slider.value)


func _on_sfx_volume_change_timer_timeout() -> void:
	_sfx_label.text = "SFX - " + str(_sfx_slider.value) + "%"
	self.change_sfx_volume.emit(_sfx_slider.value)


func _on_resolution_button_pressed() -> void:
	_is_fullscreen = !_is_fullscreen
	
	if _is_fullscreen:
		_resolution_button.text = "WINDOWED"
	else:
		_resolution_button.text = "FULLSCREEN"
	
	toggle_fullscreen.emit(_is_fullscreen)
