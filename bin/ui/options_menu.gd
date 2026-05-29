class_name OptionsMenu extends Control

@export var fullscreen_toggle_button: CheckBox
@export var resolusion_scale_dropdown: OptionButton

func _enter_tree() -> void:
	var fullscreen_button_toggled: bool
	var dropdown_item_selected: int

	match DisplayServer.window_get_mode():
		0:
			fullscreen_button_toggled = false
		3:
			fullscreen_button_toggled = true

	match get_viewport().scaling_3d_scale:
		0.5:
			dropdown_item_selected = 0
		1.0:
			dropdown_item_selected = 1
		2.0:
			dropdown_item_selected = 2

	fullscreen_toggle_button.button_pressed = fullscreen_button_toggled
	resolusion_scale_dropdown.selected = dropdown_item_selected

func _on_check_box_toggled(toggled_on: bool) -> void:
	var value: int = 0

	if toggled_on:
		value = 3

	OptionsManager.display_settings_to_buffer("window_mode", value)

func _on_option_button_item_selected(index: int) -> void:
	var value: float

	match index:
		0:
			value = 0.5
		1:
			value = 1.0
		2:
			value = 2.0

	OptionsManager.display_settings_to_buffer("resolusion_scale", value)

func _on_back_pressed() -> void:
	if OptionsManager.options_buffer.size() > 0:
		OptionsManager.options_buffer.clear()

	Global.goto_last_menu()

func _on_apply_pressed() -> void:
	OptionsManager.save_options()
	OptionsManager.apply_options()
