class_name Background
extends CanvasLayer


@onready var base: Sprite2D = %Base
@onready var lower: Sprite2D = %Lower
@onready var middle: Sprite2D = %Middle
@onready var top: Sprite2D = %Top

@export_category("Textures")
@export var base_texture: Texture2D
@export var lower_texture: Texture2D
@export var middle_texture: Texture2D
@export var top_texture: Texture2D

@export_category("TextureSize")
@export var texture_width: int = 2200
@export var texture_height: int = 2200

@export_category("Rotation")
@export_range(-250, 250) var base_rotation: float = 10
@export_range(-250, 250) var lower_rotation: float = -10
@export_range(-250, 250) var middle_rotation: float = 25
@export_range(-250, 250) var top_rotation: float = -25


func _ready() -> void:
	if base_texture:
		_set_background_sprite(base, base_texture, texture_width, texture_height)
	
	if lower_texture:
		_set_background_sprite(lower, lower_texture, texture_width, texture_height)
		
	if middle_texture:
		_set_background_sprite(middle, middle_texture, texture_width, texture_height)
	
	if top_texture:
		_set_background_sprite(top, top_texture, texture_width, texture_height)


func _process(delta: float) -> void:
	base.rotation_degrees += base_rotation * delta
	lower.rotation_degrees += middle_rotation * delta
	middle.rotation_degrees += middle_rotation * delta
	top.rotation_degrees += top_rotation * delta


func _set_background_sprite(
		sprite: Sprite2D, 
		texture: Texture2D, 
		width: float, 
		height: float
	) -> void:
	sprite.texture = texture
	sprite.scale = _scale_sprite(sprite, width, height)
	_centre_sprite(sprite)


func _centre_sprite(sprite: Sprite2D) -> void:
	sprite.position.x = get_viewport().size.x * 0.5
	sprite.position.y = get_viewport().size.y * 0.5


func _scale_sprite(sprite: Sprite2D, width: float, height: float) -> Vector2:
	var result: Vector2 = Vector2.ZERO
	
	result.x = _get_scale_factor(sprite.get_rect().size.x, width)
	result.y = _get_scale_factor(sprite.get_rect().size.y, height)
	
	return result


func _get_scale_factor(value: float, target: float) -> float:
	return snappedf(target / value, 0.01)
