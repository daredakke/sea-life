class_name SmallRockSpawner
extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer

@export var node_scene: PackedScene
@export var nodes_to_spawn: int = 20
@export var node_speed: float = 120
@export var node_speed_variance: float = 50
@export var spawn_delay: float = 1.0
@export var aim_at_player: bool = false

var nodes_spawned: int = 0

# Where to aim spawned nodes
var target: Vector2
@export var target_x_variance: float = 150
@export var target_y_variance: float = 150

var spawn_areas: Array[SpawnArea]


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = spawn_delay
	
	for child in get_children():
		if child is SpawnArea:
			spawn_areas.append(child)


func get_screen_centre() -> Vector2:
	var centre_x = get_viewport_rect().size.x * 0.5
	var centre_y = get_viewport_rect().size.y * 0.5
	
	centre_x += randf_range(-target_x_variance, target_x_variance)
	centre_y += randf_range(-target_y_variance, target_y_variance)

	return Vector2(centre_x, centre_y)


func _on_spawn_timer_timeout() -> void:
	var node_instance: Area2D = node_scene.instantiate() as Area2D
	node_instance.speed = node_speed
	node_instance.speed_variance = node_speed_variance
	
	var spawn_position: Vector2 = spawn_areas.pick_random().get_random_spawn_position()
	node_instance.global_position = spawn_position
	
	if aim_at_player:
		target = Globals.player_position
	else:
		target = get_screen_centre()
	
	node_instance.direction = spawn_position.direction_to(target)
	nodes_spawned += 1
	
	add_sibling(node_instance)
	
	if nodes_spawned >= nodes_to_spawn:
		self.queue_free()
