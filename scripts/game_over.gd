class_name GameOver
extends Control


signal restart_game

var _score: int:
	set(new_value):
		_score = new_value
		
		if Highscores.is_new_highscore(new_value):
			_show_highscore_input()

@onready var total_score_value: Label = %TotalScoreValue
@onready var enemies_killed_value: Label = %EnemiesKilledValue
@onready var new_highscore_label: Label = %NewHighscoreLabel
@onready var highscore_h_box: HBoxContainer = %HighscoreHBox
@onready var highscore_input: LineEdit = %HighscoreInput
@onready var highscore_button: Button = %HighscoreButton
@onready var return_to_title_button: Button = %ReturnToTitleButton


func _ready() -> void:
	_hide_highscore_input()
	hide()


func set_enemies_defeated(value: int) -> void:
	enemies_killed_value.text = str(value)


func set_total_score(value: int) -> void:
	_score = value
	total_score_value.text = str(value)


func _show_highscore_input() -> void:
	new_highscore_label.show()
	highscore_h_box.show()


func _hide_highscore_input() -> void:
	new_highscore_label.hide()
	highscore_h_box.hide()


func _on_highscore_button_pressed() -> void:
	pass # Replace with function body.


func _on_return_to_title_button_pressed() -> void:
	_hide_highscore_input()
	hide()
	restart_game.emit()
