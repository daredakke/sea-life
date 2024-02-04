class_name NodeSpawner
extends Node2D


@export var node_scene: PackedScene
@export var nodes_to_spawn: int = 20
@export var node_health: int = 0
@export var node_speed: float = 75
@export var node_speed_variance: float = 30
@export var start_delay: float = 0.05
@export var spawn_delay: float = 1
@export var aim_at_player: bool = false
@export var target_x_variance: float = 150
@export var target_y_variance: float = 150

var _target: Vector2
var _spawn_areas: Array[SpawnArea]
var _nodes_spawned: int = 0

@onready var start_timer: Timer = $StartTimer
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	start_timer.wait_time = start_delay
	spawn_timer.wait_time = spawn_delay
	
	start_timer.start()
	
	# Get areas for spawning nodes in
	for child in get_children():
		if child is SpawnArea:
			_spawn_areas.append(child)


func _get_screen_centre_target_area() -> Vector2:
	var centre_x = Globals.screen_centre.global_position.x
	var centre_y = Globals.screen_centre.global_position.y
	
	centre_x += randf_range(-target_x_variance, target_x_variance)
	centre_y += randf_range(-target_y_variance, target_y_variance)
	
	return Vector2(centre_x, centre_y)


func _on_start_timer_timeout() -> void:
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	var node_instance := node_scene.instantiate() as Area2D
	
	if node_health > 0:
		node_instance.health = node_health
	
	node_instance.speed = node_speed
	node_instance.speed_variance = node_speed_variance
	
	var spawn_position: Vector2 = _spawn_areas.pick_random().get_random_spawn_position()
	node_instance.global_position = spawn_position
	
	if aim_at_player:
		_target = Globals.player_position
	else:
		_target = _get_screen_centre_target_area()
	
	node_instance.defeated.connect(Waves.enemy_defeated)
	node_instance.direction = spawn_position.direction_to(_target)
	_nodes_spawned += 1
	
	add_sibling(node_instance)
	
	if _nodes_spawned >= nodes_to_spawn:
		self.queue_free()
