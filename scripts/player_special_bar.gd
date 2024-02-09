class_name PlayerSpecialBar
extends Control


@onready var _inner_margin: MarginContainer = %InnerMargin


func _ready() -> void:
	_inner_margin.size.x = 0


func update_special_bar(value: int, max_value: int) -> void:
	_inner_margin.size.x = (float(value) / max_value) * 1280
