class_name OptionsMenu extends Control

@export var window_mode_checkbox: CheckBox

func _ready() -> void:
	match Options.options.get_value("window", "window_mode"):
		0:
			window_mode_checkbox.button_pressed = false
		4:
			window_mode_checkbox.button_pressed = true

func _on_back_pressed() -> void:
	Global.emit_signal("goto_last_menu")

func _on_check_box_pressed() -> void:
	Options.window_mode()
