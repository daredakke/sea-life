class_name SmallRockSpawner
extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer

var node_scene: PackedScene
var nodes_to_spawn: int = 20
var nodes_spawned: int = 0
var spawn_delay: float = 1.0

# Where to aim spawned nodes
var target: Vector2
var target_x_variance: float
var target_y_variance: float

# Coordinates for node spawning
var top_left: Vector2 = Vector2(-50, -50)
var top_right: Vector2 = Vector2(get_viewport_rect().size.x + 50, -50)
var bottom_left: Vector2 = Vector2(-50, get_viewport_rect().size.y + 50)
var bottom_right: Vector2 = Vector2(
	get_viewport_rect().size.x + 50,
	get_viewport_rect().size.y + 50
)


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = spawn_delay


func get_screen_centre() -> void:
	var centre_x = get_viewport_rect().size.x * 0.5
	var centre_y = get_viewport_rect().size.y * 0.5

	return Vector2(centre_x, centre_y)


func _on_spawn_timer_timeout() -> void:
	var node_instance = node_scene.instantiate()
	nodes_spawned += 1

	if nodes_spawned >= nodes_to_spawn:
		self.queue_free()
