extends Node


var player_position: Vector2
var screen_centre: Vector2

@onready var score: int = 0


func update_player_position(pos: Vector2) -> void:
	player_position = pos


func remove_child_nodes(parent_node: Node) -> void:
	if parent_node.get_children().size() > 0:
		for node in parent_node.get_children():
			parent_node.remove_child(node)
			node.queue_free()


# From https://pastebin.com/STHPc0mD
func format_integer(number: int) -> String:
	var value := str(number)
	var output := ""
	
	for i in value.length():
		if i != 0 and i % 3 == value.length() % 3:
			output += ","
		
		output += value[i]
	
	return output
