class_name GameOver
extends Control


signal restart_game

@onready var total_score_value: Label = %TotalScoreValue
@onready var enemies_killed_value: Label = %EnemiesKilledValue
@onready var new_highscore_label: Label = %NewHighscoreLabel
@onready var highscore_h_box: HBoxContainer = %HighscoreHBox
@onready var highscore_input: LineEdit = %HighscoreInput
@onready var highscore_button: Button = %HighscoreButton
@onready var return_to_title_button: Button = %ReturnToTitleButton


func _ready() -> void:
	hide()


func _on_return_to_title_button_pressed() -> void:
	hide()
	restart_game.emit()


func set_enemies_defeated(value: int) -> void:
	enemies_killed_value.text = str(value)


func set_total_score(value: int) -> void:
	total_score_value.text = str(value)
