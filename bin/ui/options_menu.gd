class_name OptionsMenu extends Control

const OPTIONS_MENU_PATH: String = "user://options_menu.tres"

@export var fullscreen_toggle_button: CheckBox
@export var resolusion_scale_dropdown: OptionButton

var options_menu_values: Resource = OptionsMenuResource.new()

var applied: bool = false

func _init() -> void:
	if ResourceLoader.exists(OPTIONS_MENU_PATH):
		options_menu_values = ResourceLoader.load(OPTIONS_MENU_PATH)

func _ready() -> void:
	fullscreen_toggle_button.button_pressed = options_menu_values.window_mode_toggled
	resolusion_scale_dropdown.selected = options_menu_values.dropdown_selected

func _on_check_box_toggled(toggled_on: bool) -> void:
	var value: int = 0

	if toggled_on:
		value = 3

	OptionsManager.options_file.window_mode = value
	options_menu_values.window_mode_toggled = toggled_on

func _on_option_button_item_selected(index: int) -> void:
	var value: float

	match index:
		0:
			value = 0.5
		1:
			value = 1.0
		2:
			value = 2.0

	OptionsManager.options_file.resolusion_scale = value
	options_menu_values.dropdown_selected = resolusion_scale_dropdown.selected

func _on_back_pressed() -> void:
	Global.goto_last_menu(Global.REMOVE_FROM_CACHE)

func _on_apply_pressed() -> void:
	OptionsManager.save_options()
	OptionsManager.apply_options()

	ResourceSaver.save(options_menu_values, OPTIONS_MENU_PATH)
