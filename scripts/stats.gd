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

@onready var _points_label: Label = %PointsLabel
@onready var _wave_label: Label = %WaveLabel
@onready var _power_label: Label = %PowerLabel
@onready var _power_button: Button = %PowerButton
@onready var _fire_rate_label: Label = %FireRateLabel
@onready var _fire_rate_button: Button = %FireRateButton
@onready var _spread_label: Label = %SpreadLabel
@onready var _spread_button: Button = %SpreadButton
@onready var _speed_label: Label = %SpeedLabel
@onready var _speed_button: Button = %SpeedButton
@onready var _pierce_count_label: Label = %PierceCountLabel
@onready var _pierce_count_button: Button = %PierceCountButton
@onready var _pierce_chance_label: Label = %PierceChanceLabel
@onready var _pierce_chance_button: Button = %PierceChanceButton

var _points: int:
	set(new_value):
		_points = clamp(new_value, 0, MAX_POINTS)
		_points_label.text = _points_text
		
		if _points == 0:
			_disable_buttons()
		else:
			_enable_buttons()

var _points_text: String = "POINTS: ":
	get:
		return _points_text + str(_points)


func _ready() -> void:
	reset_points_and_stat_labels()
	hide()


func reset_points_and_stat_labels() -> void:
	_power_label.text = "0"
	_fire_rate_label.text = "0"
	_spread_label.text = "0"
	_speed_label.text = "0"
	_pierce_count_label.text = "0"
	_pierce_chance_label.text = "0"

	_points = 0

	reset_stats.emit()


func add_points(value: int) -> void:
	_points += value


func _spend_point() -> void:
	_points -= 1


func _disable_buttons() -> void:
	_power_button.disabled = true
	_fire_rate_button.disabled = true
	_spread_button.disabled = true
	_speed_button.disabled = true
	_pierce_count_button.disabled = true
	_pierce_chance_button.disabled = true


func _enable_buttons() -> void:
	_power_button.disabled = false
	_fire_rate_button.disabled = false
	_spread_button.disabled = false
	_speed_button.disabled = false
	_pierce_count_button.disabled = false
	_pierce_chance_button.disabled = false


func _increase_stat(label: Label, stat: Stat) -> void:
	if int(label.text) < MAX_STAT_VALUE:
		var new_value = int(label.text) + 1
		label.text = str(new_value)
		
		_spend_point()
		stat_increased.emit(new_value, stat)


func set_wave_text(value: int) -> void:
	_wave_label.text = "WAVE: " + str(value)


func _on_power_button_pressed() -> void:
	_increase_stat(_power_label, Stat.POWER)


func _on_fire_rate_button_pressed() -> void:
	_increase_stat(_fire_rate_label, Stat.FIRE_RATE)


func _on_spread_button_pressed() -> void:
	_increase_stat(_spread_label, Stat.SPREAD)


func _on_speed_button_pressed() -> void:
	_increase_stat(_speed_label, Stat.SPEED)


func _on_pierce_count_button_pressed() -> void:
	_increase_stat(_pierce_count_label, Stat.PIERCE_COUNT)


func _on_pierce_chance_button_pressed() -> void:
	_increase_stat(_pierce_chance_label, Stat.PIERCE_CHANCE)


func _on_close_button_pressed() -> void:
	hide()
	close_stats_screen.emit()
