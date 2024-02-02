class_name Special
extends Control

var charges: int = 0

var indicator_scene: PackedScene = preload("res://scenes/special_indicator.tscn")

@onready var indicator_h_box: HBoxContainer = %IndicatorHBox


func _ready() -> void:
	update_special_indicators()


func set_special_charges(value: int) -> void:
	charges = value
	
	update_special_indicators()


func update_special_indicators() -> void:
	Globals.remove_child_nodes(indicator_h_box)
	
	if charges > 0:
		for i in range(charges):
			var indicator_instance := indicator_scene.instantiate() as TextureRect
			
			indicator_h_box.add_child(indicator_instance)
