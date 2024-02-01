class_name GameOver
extends Control


signal restart_game


func _ready() -> void:
	hide()


func _on_return_to_title_button_pressed() -> void:
	hide()
	restart_game.emit()
