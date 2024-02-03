class_name SpawnPattern
extends Resource


@export var scene: PackedScene
@export_range(0, 1000) var nodes_to_spawn: int
@export_range(20, 2500) var speed: int
@export_range(0, 250) var speed_variance: int
@export_range(0.05, 120) var start_delay: float
@export_range(0.05, 60) var spawn_delay: float
@export var aim_at_player: bool
