class_name RockSmall
extends Area2D

var speed: float = 100
var direction: Vector2
var health: int = 3


func _process(delta):
	self.position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		health -= area.power

		if health <= 0:
			self.queue_free()


	if area.is_in_group("enemy_despawner"):
		self.queue_free()
