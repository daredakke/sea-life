class_name NodeSpawner
extends Node2D

var configuration: EnemyGroup
var _node_scene: PackedScene
var _nodes_to_spawn: int
var _node_health: int
var _node_speed: int
var _node_speed_variance: int
var _aim_at_player: bool
var _target_x_variance: float
var _target_y_variance: float

var _target: Vector2
var _spawn_areas: Array[SpawnArea]
var _nodes_spawned: int = 0

@onready var start_timer: Timer = $StartTimer
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	_node_scene = configuration.node_scene
	_nodes_to_spawn = configuration.nodes_to_spawn
	_node_health = configuration.node_health
	_node_speed = configuration.node_speed
	_node_speed_variance = configuration.node_speed_variance
	start_timer.wait_time = configuration.start_delay
	spawn_timer.wait_time = configuration.spawn_delay
	_aim_at_player = configuration.aim_at_player
	_target_x_variance = configuration.target_x_variance
	_target_y_variance = configuration.target_y_variance
	
	start_timer.start()
	
	# Get areas for spawning nodes in
	for child in get_children():
		if child is SpawnArea:
			_spawn_areas.append(child)


func _get_screen_centre_target_area() -> Vector2:
	var centre_x = Globals.screen_centre.x
	var centre_y = Globals.screen_centre.y
	
	centre_x += randf_range(-_target_x_variance, _target_x_variance)
	centre_y += randf_range(-_target_y_variance, _target_y_variance)
	
	return Vector2(centre_x, centre_y)


func _on_start_timer_timeout() -> void:
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	var node_instance := _node_scene.instantiate() as Enemy
	
	if _node_health > 0:
		node_instance.health = _node_health
	
	node_instance.speed = _node_speed
	node_instance.speed_variance = _node_speed_variance
	
	var spawn_position: Vector2 = _spawn_areas.pick_random().get_random_spawn_position()
	node_instance.global_position = spawn_position
	
	if _aim_at_player:
		_target = Globals.player_position
	else:
		_target = _get_screen_centre_target_area()
	
	node_instance.defeated.connect(Waves.enemy_defeated)
	node_instance.direction = spawn_position.direction_to(_target)
	_nodes_spawned += 1
	
	add_sibling(node_instance)
	
	if _nodes_spawned >= _nodes_to_spawn:
		self.queue_free()
