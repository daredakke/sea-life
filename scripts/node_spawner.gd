class_name SmallRockSpawner
extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer

@export var node_scene: PackedScene
var nodes_to_spawn: int = 20
var nodes_spawned: int = 0
var spawn_delay: float = 1.0

# Where to aim spawned nodes
@export_enum("SCREEN_CENTRE", "PLAYER") var target: int
var target_x_variance: float
var target_y_variance: float

var spawn_areas: Array[SpawnArea]


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = spawn_delay
	
	for child in get_children():
		if child is SpawnArea:
			spawn_areas.append(child)


func get_screen_centre() -> void:
	var centre_x = get_viewport_rect().size.x * 0.5
	var centre_y = get_viewport_rect().size.y * 0.5

	return Vector2(centre_x, centre_y)


func _on_spawn_timer_timeout() -> void:
	var node_instance = node_scene.instantiate()
	node_instance.global_position = spawn_areas.pick_random().get_random_spawn_position()
	
	add_sibling(node_instance)
	
	nodes_spawned += 1

	if nodes_spawned >= nodes_to_spawn:
		self.queue_free()
