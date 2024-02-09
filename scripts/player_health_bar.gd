class_name PlayerHealthBar
extends Control


@onready var _health_bar: ColorRect = %HealthBar
@onready var _inner_margin: MarginContainer = %InnerMargin


func update_health_bar(hp: int, max_hp: int) -> void:
	_inner_margin.size.x = (float(hp) / max_hp) * 1280
	
	var hue: float = (float(hp) / max_hp) * 0.3 - 0.04
	_health_bar.color = Color.from_hsv(hue, 0.67, 0.9, 1.0)
