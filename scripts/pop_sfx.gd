class_name PopSfx
extends AudioStreamPlayer2D


func _on_finished() -> void:
	pitch_scale = randf_range(0.95, 1.05)
