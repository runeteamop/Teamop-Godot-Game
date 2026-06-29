class_name OptionsMenu extends Control

const WINDOW_MODE_VALUES: Array[int] = [0, 3, 4]

var options: ConfigFile = OptionsManager.options_file
#var active_keymap: Button = null

@export var display_option_menu: PanelContainer
@export var audio_option_menu: PanelContainer
@export var input_option_menu: PanelContainer

@export var window_mode_selector: OptionButton
@export var resolution_scale_slider: HSlider
@export var ui_scale_slider: HSlider
@export var vsync_selector: OptionButton
@export var antialiasing_selector: OptionButton
@export var framerate_limit_slider: HSlider

@export var resolution_scale_percentage: Label
@export var ui_scale_percentage: Label
@export var framerate_limit_number: Label

@export var forward: Button

@export var default: HBoxContainer
@export var tabs: HBoxContainer
@export var confirmation: HBoxContainer

@onready var current_menu: PanelContainer = display_option_menu
@onready var indicators: Array[Node] = get_tree().get_nodes_in_group("Indicators")
@onready var input_option_buttons: Array[Node] = get_tree().get_nodes_in_group("InputOptionButtons")

func _ready() -> void:
	set_process_unhandled_input(false)

func _enter_tree() -> void:
	window_mode_selector.selected = WINDOW_MODE_VALUES.find(options.get_value("display", "window_mode"))
	resolution_scale_slider.value = options.get_value("display", "resolution_scale")
	ui_scale_slider.value = options.get_value("display", "ui_scale")
	vsync_selector.selected = options.get_value("display", "vertical_syncronization")
	antialiasing_selector.selected = options.get_value("display", "antialiasing")

	resolution_scale_percentage.text = "%s%%" % int(options.get_value("display", "resolution_scale") * 100)
	ui_scale_percentage.text = "%s%%" % int(options.get_value("display", "ui_scale") * 100)

	if options.get_value("display", "framerate_limit") == 0:
		framerate_limit_slider.value = 501
		framerate_limit_number.text = "Unlimited"
	else:
		framerate_limit_slider.value = options.get_value("display", "framerate_limit")
		framerate_limit_number.text = "%s" % str(options.get_value("display", "framerate_limit"))

func _option_changed_checker(indicator: Label, section: String, key: String, value: Variant) -> void:
	#indicator.set_modulate(Color(1, 1, 1, 1)) if options.get_value(section, key) != value else indicator.set_modulate(Color(1, 1, 1, 0))
	indicator.visible = true if OptionsManager.options_file.get_value(section, key) != value else false

func _flush_option_buffer() -> void: OptionsManager.flush_buffer()

func _reset_indicators() -> void:
	for indicator in indicators:
		indicator.visible = false

func _swap_buttons() -> void:
	default.visible = !default.visible
	tabs.visible = !tabs.visible
	confirmation.visible = !confirmation.visible

func _swap_current_menu(new_menu: PanelContainer)-> void:
	current_menu.visible = false
	current_menu = new_menu
	current_menu.visible = true

func _show_display_options() -> void: _swap_current_menu(display_option_menu)

func _show_audio_options() -> void: _swap_current_menu(audio_option_menu)

func _show_input_options() -> void: _swap_current_menu(input_option_menu)

func _apply() -> void:
	OptionsManager.save_options()
	OptionsManager.apply_all_options()

func _exit() -> void:
	Global.goto_last_menu()

func _on_back_pressed() -> void:
	if OptionsManager.options_buffer.size() > 0:
		_swap_buttons()
	else:
		_exit()

func _on_window_mode_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "window_mode", WINDOW_MODE_VALUES[index])
	_option_changed_checker(indicators[0], "display", "window_mode", WINDOW_MODE_VALUES[index])

func _on_resolution_scale_slider_value_changed(value: float) -> void:
	OptionsManager.options_to_buffer("display", "resolution_scale", value)
	_option_changed_checker(indicators[2], "display", "resolution_scale", value)
	resolution_scale_percentage.text = "%s%%" % int(value * 100)

func _on_ui_scale_slider_value_changed(value: float) -> void:
	OptionsManager.options_to_buffer("display", "ui_scale", value)
	_option_changed_checker(indicators[1], "display", "ui_scale", value)
	ui_scale_percentage.text = "%s%%" % int(value * 100)

func _on_v_sync_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "vertical_syncronization", index)
	_option_changed_checker(indicators[4], "display", "vertical_syncronization", index)

func _on_anti_aliasing_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "antialiasing", index)
	_option_changed_checker(indicators[3], "display", "antialiasing", index)

func _on_framerate_limit_slider_value_changed(value: int) -> void:
	if value == 501: value = 0
	OptionsManager.options_to_buffer("display", "framerate_limit", value)
	_option_changed_checker(indicators[5], "display", "framerate_limit", value)
	framerate_limit_number.text = "%s" % value if value != 0 else "Unlimited"

func _on_input_option_button_toggled(toggled_on: bool) -> void:
	set_process_unhandled_input(toggled_on)

func _unhandled_input(event: InputEvent) -> void:
	if event.pressed:
		var key_already_in_use: bool
		var active_button: Button
		var active_button_metadata: String
		var old_letter: InputEvent

		for button in input_option_buttons:
			for input in InputMap.action_get_events(button.get_meta_list()[0]):
				if event.as_text() == input.as_text(): key_already_in_use = true

			if button.button_pressed:
				active_button = button
				active_button_metadata = button.get_meta_list()[0]

				var selected_action = InputMap.action_get_events(active_button_metadata)
				for input in selected_action:
					if input.as_text() == button.text: old_letter = input

		if key_already_in_use:
			print("Key is already in use!")
		else:
			InputMap.action_erase_event(active_button_metadata, old_letter)
			InputMap.action_add_event(active_button_metadata, event)

			active_button.text = event.as_text()
			active_button.button_pressed = false

		print(InputMap.action_get_events(active_button_metadata))
