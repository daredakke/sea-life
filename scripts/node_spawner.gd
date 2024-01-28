class_name NodeSpawner
extends Node2D


@export var node_scene: PackedScene
@export var nodes_to_spawn: int = 20
@export var node_speed: float = 75
@export var node_speed_variance: float = 30
@export var spawn_delay: float = 1
@export var aim_at_player: bool = false
@export var target_x_variance: float = 150
@export var target_y_variance: float = 150

var _target: Vector2
var _spawn_areas: Array[SpawnArea]
var _nodes_spawned: int = 0

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = spawn_delay
	
	for child in get_children():
		if child is SpawnArea:
			_spawn_areas.append(child)


func _get_screen_centre_target_area() -> Vector2:
	var centre_x = get_viewport_rect().size.x * 0.5
	var centre_y = get_viewport_rect().size.y * 0.5
	
	centre_x += randf_range(-target_x_variance, target_x_variance)
	centre_y += randf_range(-target_y_variance, target_y_variance)

	return Vector2(centre_x, centre_y)


func _on_spawn_timer_timeout() -> void:
	var node_instance := node_scene.instantiate() as Area2D
	node_instance.speed = node_speed
	node_instance.speed_variance = node_speed_variance
	
	var spawn_position: Vector2 = _spawn_areas.pick_random().get_random_spawn_position()
	node_instance.global_position = spawn_position
	
	if aim_at_player:
		_target = Globals.player_position
	else:
		_target = _get_screen_centre_target_area()
	
	node_instance.tree_exited.connect(Waves.enemy_defeated)
	node_instance.direction = spawn_position.direction_to(_target)
	_nodes_spawned += 1
	
	add_sibling(node_instance)
	
	if _nodes_spawned >= nodes_to_spawn:
		self.queue_free()
