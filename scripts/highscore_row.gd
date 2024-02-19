class_name HighscoreRow
extends HBoxContainer


var rank_text: int
var name_text: String
var score: int

@onready var rank_label: Label = $RankLabel
@onready var name_label: Label = $NameLabel
@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	rank_label.text = "#" + str(rank_text)
	name_label.text = name_text
	score_label.text = Globals.format_integer(score)
