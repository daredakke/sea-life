class_name Options
extends Control

signal toggle_fullscreen(state: bool)
signal change_music_volume(value: float)
signal change_sfx_volume(value: float)

@onready var music_label: Label = %MusicLabel
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_label: Label = %SFXLabel
@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_volume_change_timer: Timer = %MusicVolumeChangeTimer
@onready var sfx_volume_change_timer: Timer = %SFXVolumeChangeTimer
@onready var resolution_button: Button = %ResolutionButton

var is_fullscreen: bool = false


func _ready() -> void:
	self.hide()


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
	is_fullscreen = !is_fullscreen
	
	if is_fullscreen:
		resolution_button.text = "WINDOWED"
	else:
		resolution_button.text = "FULLSCREEN"
	
	toggle_fullscreen.emit(is_fullscreen)
