class_name OptionsMenu extends Control

#const WINDOW_MODE_VALUES: Array[int] = [0, 3]
const RESOLUSIONS: Array[Vector2] = [Vector2(1280, 720), Vector2(1920, 1080), Vector2(2560, 1440), Vector2(3840, 2160)]
const RESOLUSION_SCALE_VALUES: Array[float] = [0.5, 1.0, 2.0]

@export var fullscreen_toggle_button: CheckBox
@export var resolusion_scale_dropdown: OptionButton
@export var resolusions: OptionButton

var options_menu_values: Resource = OptionsMenuResource.new()

var applied: bool = false

func _enter_tree() -> void:
	fullscreen_toggle_button.button_pressed = true if OptionsManager.options_file.get_value("display", "window_mode", 3) else false
	resolusion_scale_dropdown.selected = RESOLUSION_SCALE_VALUES.find(OptionsManager.options_file.get_value("display", "resolusion_scale"))
	resolusions.selected = RESOLUSIONS.find(get_viewport().get_visible_rect().size)
	
	print(get_viewport().get_visible_rect().size)

func _on_check_box_toggled(toggled_on: bool) -> void:
	OptionsManager.options_to_buffer("display", "window_mode", 4 if toggled_on else 0)
	#OptionsManager.options_buffer.set_value("display", "window_mode", 3 if toggled_on else 0)

func _on_option_button_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "resolusion_scale", RESOLUSION_SCALE_VALUES[index])
	#OptionsManager.options_file.set_value("display", "resolusion_scale", RESOLUSION_SCALE_VALUES[index])

func _on_back_pressed() -> void:
	Global.goto_last_menu()

func _on_apply_pressed() -> void:
	OptionsManager.save_options()
	OptionsManager.apply_all_options()
	
func _on_option_button_2_item_selected(index: int) -> void:
	get_window().set_size(RESOLUSIONS[index])
	#DisplayServer.window_set_position(DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()) * 2)
	var t = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var e = get_window().get_size_with_decorations()
	print(t-e)
	get_window().set_position(t-e/2)
	
