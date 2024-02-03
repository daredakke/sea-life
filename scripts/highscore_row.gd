class_name HighscoreRow
extends HBoxContainer


var name_text: String
var score: int

@onready var name_label: Label = $NameLabel
@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	name_label.text = name_text
	score_label.text = str(score)
