class_name Background
extends CanvasLayer

@onready var base: Sprite2D = %Base
@onready var middle: Sprite2D = %Middle
@onready var top: Sprite2D = %Top

@export_category("Textures")
@export var base_texture: Texture2D
@export var middle_texture: Texture2D
@export var top_texture: Texture2D

@export_category("TextureSize")
@export var texture_width: int = 2200
@export var texture_height: int = 2200

@export_category("Rotation")
@export_range(-250, 250) var base_rotation: float = 10
@export_range(-250, 250) var middle_rotation: float = 30
@export_range(-250, 250) var top_rotation: float = -20


func _ready() -> void:
	if base_texture:
		set_background_sprite(base, base_texture, texture_width, texture_height)
	
	if middle_texture:
		set_background_sprite(middle, middle_texture, texture_width, texture_height)
	
	if top_texture:
		set_background_sprite(top, top_texture, texture_width, texture_height)


func _process(delta: float) -> void:
	base.rotation_degrees += base_rotation * delta
	middle.rotation_degrees += middle_rotation * delta
	top.rotation_degrees += top_rotation * delta


func set_background_sprite(
		sprite: Sprite2D, 
		texture: Texture2D, 
		width: float, 
		height: float
	) -> void:
	sprite.texture = texture
	sprite.scale = scale_sprite(sprite, width, height)
	centre_sprite(sprite)


func centre_sprite(sprite: Sprite2D) -> void:
	sprite.position.x = get_viewport().size.x * 0.5
	sprite.position.y = get_viewport().size.y * 0.5


func scale_sprite(sprite: Sprite2D, width: float, height: float) -> Vector2:
	var result: Vector2 = Vector2.ZERO
	
	result.x = get_scale_factor(sprite.get_rect().size.x, width)
	result.y = get_scale_factor(sprite.get_rect().size.y, height)
	
	return result


func get_scale_factor(value: float, target: float) -> float:
	return snappedf(target / value, 0.01)
