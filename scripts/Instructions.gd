class_name Instructions
extends MarginContainer


var _page: int = 1

@onready var page_label: Label = %PageLabel
@onready var prev_button: Button = %PrevButton
@onready var instructions_v_box: VBoxContainer = %InstructionsVBox
@onready var screenshot_spacer_panel: Panel = %ScreenshotSpacerPanel
@onready var next_button: Button = %NextButton


func change_page(page: int) -> void:
	_page = clampi(page, 1, 2)
	
	if page == 1:
		page_label.text = "CONTROLS"
		prev_button.disabled = true
		next_button.disabled = false
		instructions_v_box.show()
		screenshot_spacer_panel.hide()
	else:
		page_label.text = "HUD"
		prev_button.disabled = false
		next_button.disabled = true
		instructions_v_box.hide()
		screenshot_spacer_panel.show()


func _on_prev_button_pressed() -> void:
	change_page(1)


func _on_next_button_pressed() -> void:
	change_page(2)
