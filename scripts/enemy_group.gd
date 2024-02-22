class_name EnemyGroup
extends Resource


@export var node_scene: PackedScene
@export_range(0, 1000) var nodes_to_spawn: int = 10
## Leave at 0 to use the node's default health
@export_range(0, 10000) var node_health: int = 0
@export_range(20, 2500) var node_speed: int = 80
@export_range(0, 250) var node_speed_variance: int = 30
@export_range(0.05, 120) var start_delay: float = 0.05
@export_range(0.05, 60) var spawn_delay: float = 1.0
@export var aim_at_player: bool = false
