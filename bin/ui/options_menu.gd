class_name OptionsMenu extends Control

const WINDOW_MODE_VALUES: Array[int] = [0, 3, 4]
#const RESOLUTIONS: Array[Vector2] = [Vector2(1280, 720), Vector2(1920, 1080), Vector2(2560, 1440), Vector2(3840, 2160)]

#@export var test: Label
@export var window_mode_selector: OptionButton
@export var resolution_scale_slider: HSlider
@export var ui_scale_slider: HSlider
@export var vsync_selector: OptionButton

func _option_changed() -> Node:
	var option_changed = Label.new()
	option_changed.text = "*"
	
	return option_changed

func _enter_tree() -> void:
	window_mode_selector.selected = WINDOW_MODE_VALUES.find(OptionsManager.options_file.get_value("display", "window_mode"))
	resolution_scale_slider.value = OptionsManager.options_file.get_value("display", "resolution_scale")
	ui_scale_slider.value = OptionsManager.options_file.get_value("display", "ui_scale")
	vsync_selector.selected = OptionsManager.options_file.get_value("display", "vertical_syncronization")

func _on_back_pressed() -> void:
	Global.goto_last_menu()

func _on_apply_pressed() -> void:
	OptionsManager.save_options()
	OptionsManager.apply_all_options()

func _on_window_mode_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "window_mode", WINDOW_MODE_VALUES[index])

func _on_resolution_scale_slider_value_changed(value: float) -> void:
	OptionsManager.options_to_buffer("display", "resolution_scale", value)

func _on_ui_scale_slider_value_changed(value: float) -> void:
	OptionsManager.options_to_buffer("display", "ui_scale", value)

func _on_v_sync_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "vertical_syncronization", index)
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer4.add_child(_option_changed())

func _on_anti_aliasing_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "antialiasing", index)
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer5.add_child(_option_changed())
	
	
