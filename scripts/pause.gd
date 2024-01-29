class_name Pause
extends Control


signal start_new_game
signal continue_game
signal change_music_volume(value: float)
signal change_sfx_volume(value: float)

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

var _is_fullscreen: bool = false

@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var quit_button: Button = %QuitButton
@onready var music_label: Label = %MusicLabel
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_label: Label = %SFXLabel
@onready var sfx_slider: HSlider = %SFXSlider
@onready var resolution_button: Button = %ResolutionButton


func _ready() -> void:
	continue_button.hide()
	show()


func _on_music_slider_value_changed(value: float) -> void:
	music_label.text = "MUSIC - " + str(value) + "%"
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus, value < 0.05)


func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_label.text = "SFX - " + str(value) + "%"
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus, value < 0.05)


func _on_resolution_button_pressed() -> void:
	_is_fullscreen = !_is_fullscreen
	
	if _is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		resolution_button.text = "WINDOWED"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		ProjectSettings.set_setting("display/window/size/borderless", false)
		
		resolution_button.text = "FULLSCREEN"


func _on_continue_button_pressed() -> void:
	hide()
	continue_game.emit()


func _on_new_game_button_pressed() -> void:
	hide()
	start_new_game.emit()


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
