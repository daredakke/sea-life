class_name Stats
extends Control

signal stat_increased(value: int, stat: int)
signal close_stats_screen
signal reset_stats

const MAX_POINTS: int = 999
const MAX_STAT_VALUE: int = 10

enum Stat {
	POWER,
	FIRE_RATE,
	SPREAD,
	SPEED,
	PIERCE_COUNT,
	PIERCE_CHANCE
}

@onready var points_label: Label = %PointsLabel
@onready var power_label: Label = %PowerLabel
@onready var power_button: Button = %PowerButton
@onready var fire_rate_label: Label = %FireRateLabel
@onready var fire_rate_button: Button = %FireRateButton
@onready var spread_label: Label = %SpreadLabel
@onready var spread_button: Button = %SpreadButton
@onready var speed_label: Label = %SpeedLabel
@onready var speed_button: Button = %SpeedButton
@onready var pierce_count_label: Label = %PierceCountLabel
@onready var pierce_count_button: Button = %PierceCountButton
@onready var pierce_chance_label: Label = %PierceChanceLabel
@onready var pierce_chance_button: Button = %PierceChanceButton

var points: int:
	set(new_value):
		points = clamp(new_value, 0, MAX_POINTS)
		points_label.text = points_text
		
		if points == 0:
			disable_buttons()
		else:
			enable_buttons()

var points_text: String = "POINTS: ":
	get:
		return points_text + str(points)


func _ready() -> void:
	reset_points()
	self.hide()


func toggle_visibility() -> void:
	if self.visible:
		self.hide()
	else:
		self.show()


func disable_buttons() -> void:
	power_button.disabled = true
	fire_rate_button.disabled = true
	spread_button.disabled = true
	speed_button.disabled = true
	pierce_count_button.disabled = true
	pierce_chance_button.disabled = true


func enable_buttons() -> void:
	power_button.disabled = false
	fire_rate_button.disabled = false
	spread_button.disabled = false
	speed_button.disabled = false
	pierce_count_button.disabled = false
	pierce_chance_button.disabled = false


func reset_points() -> void:
	power_label.text = "0"
	fire_rate_label.text = "0"
	spread_label.text = "0"
	speed_label.text = "0"
	pierce_count_label.text = "0"
	pierce_chance_label.text = "0"
	
	points = 0
	
	self.reset_stats.emit()


func spend_point() -> void:
	points -= 1


func increase_stat(label: Label, stat: Stat) -> void:
	if int(label.text) < MAX_STAT_VALUE:
		var new_value = int(label.text) + 1
		label.text = str(new_value)
		
		spend_point()
		self.stat_increased.emit(new_value, stat)


func _on_power_button_pressed() -> void:
	increase_stat(power_label, Stat.POWER)


func _on_fire_rate_button_pressed() -> void:
	increase_stat(fire_rate_label, Stat.FIRE_RATE)


func _on_spread_button_pressed() -> void:
	increase_stat(spread_label, Stat.SPREAD)


func _on_speed_button_pressed() -> void:
	increase_stat(speed_label, Stat.SPEED)


func _on_pierce_count_button_pressed() -> void:
	increase_stat(pierce_count_label, Stat.PIERCE_COUNT)


func _on_pierce_chance_button_pressed() -> void:
	increase_stat(pierce_chance_label, Stat.PIERCE_CHANCE)


func _on_close_button_pressed() -> void:
	self.close_stats_screen.emit()
