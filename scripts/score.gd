class_name Score
extends Control


@onready var score_label: Label = %ScoreLabel


func _ready() -> void:
	set_score_label(0)


func set_score_label(score: int) -> void:
	score_label.text = str(score)
