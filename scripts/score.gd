class_name Score
extends Control


@onready var score_label: Label = %ScoreLabel
@onready var multiplier_label: Label = %MultiplierLabel


func _ready() -> void:
	set_score_label(0)
	set_multiplier_label(1)


func set_score_label(score: int) -> void:
	score_label.text = Globals.format_integer(score)


func set_multiplier_label(multiplier: int) -> void:
	multiplier_label.text = "x" + str(multiplier)
