class_name Pause
extends Control


signal start_new_game
signal continue_game
signal change_music_volume(value: float)
signal change_sfx_volume(value: float)

var music_bus := AudioServer.get_bus_index("Music")
var sfx_bus := AudioServer.get_bus_index("SFX")

var _is_fullscreen: bool = false
var _highscore_row_scene: PackedScene = preload("res://scenes/highscore_row.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var options_button: Button = %OptionsButton
@onready var highscores_button: Button = %HighscoresButton
@onready var instructions_button: Button = %InstructionsButton
@onready var quit_button: Button = %QuitButton
@onready var music_label: Label = %MusicLabel
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_label: Label = %SFXLabel
@onready var sfx_slider: HSlider = %SFXSlider
@onready var resolution_button: Button = %ResolutionButton
@onready var highscore_v_box: VBoxContainer = %HighscoreVBox
@onready var options: MarginContainer = %Options
@onready var highscores: MarginContainer = %Highscores
@onready var instructions: Instructions = %Instructions


func _ready() -> void:
	animation_player.play("boiling")
	display_highscores()
	continue_button.hide()
	close_modals()
	
	new_game_button.disabled = true
	quit_button.disabled = true
	resolution_button.disabled = true


func enable_buttons() -> void:
	new_game_button.disabled = false
	quit_button.disabled = false
	resolution_button.disabled = false


func close_modals() -> void:
	options.hide()
	highscores.hide()
	instructions.hide()


func display_highscores() -> void:
	_clear_highscore_list()
	
	if Highscores.scores["scores"].is_empty():
		return
	
	for i in range(Highscores.scores["scores"].size()):
		var score_name = Highscores.scores["names"][i]
		var score = Highscores.scores["scores"][i]
		var highscore_row_instance := _highscore_row_scene.instantiate() as HBoxContainer
		
		highscore_row_instance.rank_text = i + 1
		highscore_row_instance.name_text = score_name
		highscore_row_instance.score = score
		
		highscore_v_box.add_child(highscore_row_instance)


func _clear_highscore_list() -> void:
	for node in highscore_v_box.get_children():
		if node.is_in_group("highscore_row"):
			highscore_v_box.remove_child(node)
			node.queue_free()


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
	continue_game.emit()


func _on_new_game_button_pressed() -> void:
	continue_button.show()
	start_new_game.emit()


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_options_button_pressed() -> void:
	options.show()


func _on_options_close_button_pressed() -> void:
	options.hide()


func _on_highscores_button_pressed() -> void:
	highscores.show()


func _on_close_highscores_button_pressed() -> void:
	highscores.hide()


func _on_instructions_button_pressed() -> void:
	instructions.change_page(1)
	instructions.show()


func _on_close_instructions_button_pressed() -> void:
	instructions.hide()
