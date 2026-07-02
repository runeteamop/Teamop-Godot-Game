class_name OptionsMenu extends Control

const WINDOW_MODE_VALUES: Array[int] = [0, 3, 4]

var options: ConfigFile = OptionsManager.options_file
var active_input_button: Button
var active_input_button_old_text: String
var options_buffer_blocked: bool

# Bottom panel menus & buttons
@export var bottom_panel_default_menu: HBoxContainer
@export var default_menu_back: Button
@export var default_menu_apply: Button
@export var display_option_button: Button
@export var audio_option_button: Button
@export var input_option_button: Button

@export var bottom_panel_confirmation_menu: HBoxContainer
@export var confirmation_menu_return: Button
@export var confirmation_menu_discard: Button
@export var confirmation_menu_apply: Button

# Option menus
@export var display_option_menu: PanelContainer
@export var audio_option_menu: PanelContainer
@export var input_option_menu: PanelContainer

# Display options
@export var window_mode_selector: OptionButton

@export var resolution_scale_slider: HSlider
@export var resolution_scale_percentage: Label

@export var ui_scale_slider: HSlider
@export var ui_scale_percentage: Label

@export var vsync_selector: OptionButton

@export var antialiasing_selector: OptionButton

@export var framerate_limit_slider: HSlider
@export var framerate_limit_number: Label

@onready var current_menu: PanelContainer = display_option_menu
@onready var current_bottom_bar: HBoxContainer = bottom_panel_default_menu
@onready var indicators: Array[Node] = get_tree().get_nodes_in_group("Indicators")
@onready var input_button_group: Array[Node] = get_tree().get_nodes_in_group("InputOptionButtons")

func _ready() -> void:
	set_process_unhandled_input(false)
	_set_options_to_option_file_values()

	default_menu_back.pressed.connect(_on_default_menu_back_pressed)
	default_menu_apply.pressed.connect(_on_default_menu_apply_pressed)

	display_option_button.pressed.connect(_on_display_option_button_pressed)
	audio_option_button.pressed.connect(_on_audio_option_button_pressed)
	input_option_button.pressed.connect(_on_input_option_button_pressed)

	confirmation_menu_return.pressed.connect(_on_confirmation_menu_return_pressed)
	confirmation_menu_discard.pressed.connect(_on_confirmation_menu_discard_pressed)
	confirmation_menu_apply.pressed.connect(_on_confirmation_menu_apply_pressed)

	window_mode_selector.item_selected.connect(_on_window_mode_selector_item_selected)
	resolution_scale_slider.value_changed.connect(_on_resolution_scale_slider_value_changed)
	ui_scale_slider.value_changed.connect(_on_ui_scale_slider_value_changed)
	vsync_selector.item_selected.connect(_on_v_sync_selector_item_selected)
	antialiasing_selector.item_selected.connect(_on_antialiasing_selector_item_selected)
	framerate_limit_slider.value_changed.connect(_on_framerate_limit_slider_value_changed)

# Called when a corresponding node is handled
func _on_default_menu_back_pressed() -> void:
	if OptionsManager.options_buffer.size() > 0:
		_swap_bottom_panel_buttons(bottom_panel_confirmation_menu)
	else:
		_exit_options()

func _on_default_menu_apply_pressed() -> void:
	_apply_options()
	_clean_options_menu()

func _on_display_option_button_pressed() -> void:
	_swap_current_menu(display_option_menu)

func _on_audio_option_button_pressed() -> void:
	_swap_current_menu(audio_option_menu)

func _on_input_option_button_pressed() -> void:
	_swap_current_menu(input_option_menu)

func _on_confirmation_menu_return_pressed() -> void:
	_swap_bottom_panel_buttons(bottom_panel_default_menu)

func _on_confirmation_menu_discard_pressed() -> void:
	_exit_options()

func _on_confirmation_menu_apply_pressed() -> void:
	_apply_options()
	_exit_options()

func _on_window_mode_selector_item_selected(index: int) -> void:
	_option_changed_checker(indicators[0], "display", "window_mode", WINDOW_MODE_VALUES[index])

func _on_ui_scale_slider_value_changed(value: float) -> void:
	_option_changed_checker(indicators[1], "display", "ui_scale", value)
	ui_scale_percentage.text = "%s%%" % int(value * 100)

func _on_resolution_scale_slider_value_changed(value: float) -> void:
	_option_changed_checker(indicators[2], "display", "resolution_scale", value)
	resolution_scale_percentage.text = "%s%%" % int(value * 100)

func _on_antialiasing_selector_item_selected(index: int) -> void:
	_option_changed_checker(indicators[3], "display", "antialiasing", index)

func _on_v_sync_selector_item_selected(index: int) -> void:
	_option_changed_checker(indicators[4], "display", "vertical_syncronization", index)

func _on_framerate_limit_slider_value_changed(value: int) -> void:
	if value == 501: value = 0
	_option_changed_checker(indicators[5], "display", "framerate_limit", value)
	framerate_limit_number.text = "%s" % value if value != 0 else "Unlimited"

func _on_input_option_button_toggled(toggled_on: bool) -> void:
	_get_pressed_input_button(toggled_on)
	set_process_unhandled_key_input(toggled_on)

func _flush_option_buffer() -> void: OptionsManager.flush_buffer()

func _clean_options_menu() -> void:
	for indicator in indicators:
		indicator.visible = false

		_set_options_to_option_file_values()

func _set_options_to_option_file_values() -> void:
	options_buffer_blocked = true

	for indicator in indicators:
		indicator.visible = false

	window_mode_selector.selected = WINDOW_MODE_VALUES.find(options.get_value("display", "window_mode"))

	resolution_scale_slider.value = options.get_value("display", "resolution_scale")
	resolution_scale_percentage.text = "%s%%" % int(options.get_value("display", "resolution_scale") * 100)

	ui_scale_slider.value = options.get_value("display", "ui_scale")
	ui_scale_percentage.text = "%s%%" % int(options.get_value("display", "ui_scale") * 100)

	vsync_selector.selected = options.get_value("display", "vertical_syncronization")

	antialiasing_selector.selected = options.get_value("display", "antialiasing")

	if options.get_value("display", "framerate_limit") == 0:
		framerate_limit_slider.value = 501
		framerate_limit_number.text = "Unlimited"
	else:
		framerate_limit_slider.value = options.get_value("display", "framerate_limit")
		framerate_limit_number.text = "%s" % str(options.get_value("display", "framerate_limit"))

	for button in input_button_group:
		button.text = options.get_value("input", button.get_meta("action")).to_upper()

	OptionsManager.flush_buffer()

	options_buffer_blocked = false

func _swap_bottom_panel_buttons(new_bar: HBoxContainer) -> void:
	current_bottom_bar.visible = false
	new_bar.visible = true
	current_bottom_bar = new_bar

func _swap_current_menu(new_menu: PanelContainer)-> void:
	current_menu.visible = false
	new_menu.visible = true
	current_menu = new_menu

func _show_audio_options() -> void: _swap_current_menu(audio_option_menu)

func _show_input_options() -> void: _swap_current_menu(input_option_menu)

func _deactivate_active_button(text: String = active_input_button_old_text) -> void:
	active_input_button.text = text
	active_input_button.button_pressed = false
	active_input_button = null
	active_input_button_old_text = ""

func _get_pressed_input_button(toggled_on: bool) -> void:
	if toggled_on:
		# If a button is already active, the button text gets set to the value of
		# "active_input_button".
		if active_input_button:
			_deactivate_active_button()
			#_swap_await_message_with_input()

		# Sets the "active_input_button" variable to the currently selected button,
		# and grabs its text before it is changed to "Awaiting input...".
		for button in input_button_group:
			if button.button_pressed:
				active_input_button = button
				active_input_button_old_text = button.text
				button.text = "Awaiting input..."

func _unhandled_input(event: InputEvent) -> void:
	if event.pressed:
		print(event.as_text())
	#if event.pressed:
		#match event.keycode:
			#KEY_ESCAPE:
				#_deactivate_active_button()
			#_:
				#var event_lower_case: String = event.as_text().to_lower()
#
				#if event is InputEventKey && event_lower_case in OptionsManager.KEYS:
					#for button in input_button_group:
						#if button.text == event.as_text():
							#_option_changed_checker(indicators[button.get_meta("index")], "input",
							#button.get_meta("action"), active_input_button_old_text.to_lower())
							#button.text = active_input_button_old_text
#
				#_option_changed_checker(indicators[active_input_button.get_meta("index")], "input",
				#active_input_button.get_meta("action"), event_lower_case)
#
				## Deactivates the selected button, sets the buttons text to the pressed key,
				## and flushes its associated variables.
				#_deactivate_active_button(event.as_text())

func _option_changed_checker(indicator: Label, key: String, subkey: String, value: Variant) -> void:
	if OptionsManager.options_file.get_value(key, subkey) != value:
		indicator.visible = true
		if !options_buffer_blocked: OptionsManager.options_to_buffer(key, subkey, value)
	else:
		indicator.visible = false
		OptionsManager.options_buffer.erase(subkey)

func _apply_options() -> void:
	if active_input_button: _deactivate_active_button()

	OptionsManager.save_options()
	OptionsManager.apply_display_options()
	OptionsManager.apply_input_options()

func _exit_options() -> void: Global.goto_last_menu(Global.REMOVE_CACHE)
