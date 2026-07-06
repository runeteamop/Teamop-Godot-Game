class_name OptionsMenu extends Control

# Variables to convert the values in the options.ini file, into the corrisponding
# values used by the buttons that change the setting:
const WINDOW_MODE_VALUES: Array[int] = [0, 3, 4]

# Color Enum:
enum COLOR {WHITE, RED}

# Saves text on input button:
var input_button_label_buffer: String
var current_input_button_toggled: Button

# Checks if input buttons overlap:
var input_buttons_overlap: bool

# Bottom panel menus & buttons:
@export var bottom_panel_default_menu: HBoxContainer
@export var default_menu_back: Button
@export var default_menu_apply: Button
@export var display_tab: Button
@export var audio_tab: Button
@export var input_tab: Button

@export var bottom_panel_confirmation_menu: HBoxContainer
@export var confirmation_menu_return: Button
@export var confirmation_menu_discard: Button
@export var confirmation_menu_apply: Button

# Option menus:
@export var display_option_menu: PanelContainer
@export var audio_option_menu: PanelContainer
@export var input_option_menu: PanelContainer

# Display options:
@export var window_mode_label: Label
@export var window_mode_selector: OptionButton

@export var resolution_scale_label: Label
@export var resolution_scale_slider: HSlider
@export var resolution_scale_percentage: Label

@export var ui_scale_label: Label
@export var ui_scale_slider: HSlider
@export var ui_scale_percentage: Label

@export var vsync_selector_label: Label
@export var vsync_selector: OptionButton

@export var antialiasing_selector_label: Label
@export var antialiasing_selector: OptionButton

@export var framerate_limit_label: Label
@export var framerate_limit_slider: HSlider
@export var framerate_limit_number: Label

# Audio options:
@export var master_volume_label: Label
@export var master_volume_slider: HSlider
@export var master_volume_percentage: Label

# Display options:
@export var move_forward_label: Label
@export var move_forward_button: Button

@export var move_left_label: Label
@export var move_left_button: Button

@export var move_backward_label: Label
@export var move_backward_button: Button

@export var move_right_label: Label
@export var move_right_button: Button

# Variables defined when the node is done loading
@onready var current_menu: PanelContainer = display_option_menu
@onready var current_bottom_bar: HBoxContainer = bottom_panel_default_menu
@onready var option_labels: Array[Node] = get_tree().get_nodes_in_group("Option labels")
@onready var input_option_buttons: Array[Node] = get_tree().get_nodes_in_group("Input buttons")

func _ready() -> void:
	set_process_unhandled_input(false)
	_set_options_to_option_file_values()

	# Default menu:
	default_menu_back.pressed.connect(_on_default_menu_back_pressed)
	default_menu_apply.pressed.connect(_on_default_menu_apply_pressed)
	display_tab.pressed.connect(_on_option_tab_pressed.bind(display_option_menu), 1)
	audio_tab.pressed.connect(_on_option_tab_pressed.bind(audio_option_menu), 1)
	input_tab.pressed.connect(_on_option_tab_pressed.bind(input_option_menu), 1)

	# Confirmation menu:
	confirmation_menu_return.pressed.connect(_on_confirmation_menu_return_pressed)
	confirmation_menu_discard.pressed.connect(_on_confirmation_menu_discard_pressed)
	confirmation_menu_apply.pressed.connect(_on_confirmation_menu_apply_pressed)

	# Display options:
	window_mode_selector.item_selected.connect(_on_window_mode_selector_item_selected)
	resolution_scale_slider.value_changed.connect(_on_resolution_scale_slider_value_changed)
	ui_scale_slider.value_changed.connect(_on_ui_scale_slider_value_changed)
	vsync_selector.item_selected.connect(_on_v_sync_selector_item_selected)
	antialiasing_selector.item_selected.connect(_on_antialiasing_selector_item_selected)
	framerate_limit_slider.value_changed.connect(_on_framerate_limit_slider_value_changed)

	# Audio options:
	master_volume_slider.value_changed.connect(_on_master_volume_slider_value_changed)

	# Input options:
	move_forward_button.toggled.connect(_on_input_button_toggled.bind(move_forward_button, move_forward_label, "move_forward"), 3)
	move_left_button.toggled.connect(_on_input_button_toggled.bind(move_left_button, move_left_label, "move_left"), 3)
	move_backward_button.toggled.connect(_on_input_button_toggled.bind(move_backward_button, move_backward_label, "move_backward"), 3)
	move_right_button.toggled.connect(_on_input_button_toggled.bind(move_right_button, move_right_label, "move_right"), 3)

# Default menu:
func _on_default_menu_back_pressed() -> void:
	if OptionsManager.options_buffer.size() > 0:
		_swap_bottom_panel_buttons(bottom_panel_confirmation_menu)
	else:
		_exit_options()

func _on_default_menu_apply_pressed() -> void:
	if current_input_button_toggled: _disable_toggled_input_button()
	_apply_options()

func _on_option_tab_pressed(option_menu: PanelContainer) -> void:
	_swap_current_menu(option_menu)

# confirmation menu:
func _on_confirmation_menu_return_pressed() -> void:
	_swap_bottom_panel_buttons(bottom_panel_default_menu)

func _on_confirmation_menu_discard_pressed() -> void:
	OptionsManager.flush_buffer()
	_exit_options()

func _on_confirmation_menu_apply_pressed() -> void:
	if current_input_button_toggled: _disable_toggled_input_button()
	_apply_options()
	_exit_options()

# Display options:
func _on_window_mode_selector_item_selected(index: int) -> void:
	_update_option(window_mode_label, "display", "window_mode", WINDOW_MODE_VALUES[index])

func _on_ui_scale_slider_value_changed(value: float) -> void:
	_update_option(ui_scale_label, "display", "ui_scale", value)
	ui_scale_percentage.text = "%s%%" % int(value * 100)

func _on_resolution_scale_slider_value_changed(value: float) -> void:
	_update_option(resolution_scale_label, "display", "resolution_scale", value)
	resolution_scale_percentage.text = "%s%%" % int(value * 100)

func _on_antialiasing_selector_item_selected(index: int) -> void:
	_update_option(antialiasing_selector_label, "display", "antialiasing", index)

func _on_v_sync_selector_item_selected(index: int) -> void:
	_update_option(vsync_selector_label, "display", "vertical_syncronization", index)

func _on_framerate_limit_slider_value_changed(value: int) -> void:
	if value == 501: value = 0
	_update_option(framerate_limit_label, "display", "framerate_limit", value)
	framerate_limit_number.text = "%s" % value if value != 0 else "Unlimited"

# AUdio options:
func _on_master_volume_slider_value_changed():
	pass

# Input options:
func _on_input_button_toggled(toggled_on: bool, button: Button, label: Label, subkey: String) -> void:
	_update_input_button_text(toggled_on, button, label, subkey)
	set_process_unhandled_input(toggled_on)

# Swap functions for bottom panel & option menu
func _swap_bottom_panel_buttons(new_bar: HBoxContainer) -> void:
	current_bottom_bar.visible = false
	new_bar.visible = true
	current_bottom_bar = new_bar

func _swap_current_menu(option_menu: PanelContainer)-> void:
	if current_menu == input_option_menu: _disable_toggled_input_button()
	current_menu.visible = false
	option_menu.visible = true
	current_menu = option_menu

func _update_input_button_text(toggled_on: bool, button: Button, label: Label, subkey: String) -> void:
	if !toggled_on:
		button.text = input_button_label_buffer

		_update_option(label, "input", subkey, button.text.to_lower())
		_button_overlap_checker()
	else:
		_button_overlap_checker()

		if current_input_button_toggled != button:
			input_button_label_buffer = button.text

		button.text = "Awaiting input..."
		current_input_button_toggled = button
		_update_input_button_color(button, COLOR.WHITE)

func _disable_toggled_input_button() -> void:
	if current_input_button_toggled:
		current_input_button_toggled.button_pressed = false

func _unhandled_input(event: InputEvent) -> void:
	if event.pressed && event is InputEventKey:
		var event_text = event.as_text()

		if event.keycode == KEY_ESCAPE:
				current_input_button_toggled.text = input_button_label_buffer
				_disable_toggled_input_button()
				_button_overlap_checker()
		elif OptionsManager.KEYS.has(event_text.to_lower()):
			current_input_button_toggled.text = event_text
			input_button_label_buffer = event_text

			_disable_toggled_input_button()
			_button_overlap_checker()
		else:
			print("Input not accepted")

func _button_overlap_checker() -> void:
		# Check button overlap:
		var identical_button_checker: Dictionary[String, Button] = {}
		var identical_buttons: Array[Button]

		for button in input_option_buttons:
			if identical_button_checker.has(button.text):
				_update_input_button_color(identical_button_checker[button.text], COLOR.RED)
				_update_input_button_color(button, COLOR.RED)
				identical_buttons.append(identical_button_checker[button.text])
				identical_buttons.append(button)
			else:
				_update_input_button_color(button, COLOR.WHITE)
				identical_button_checker[button.text] = button

		default_menu_apply.disabled = true if identical_buttons.size() > 0 else false
		confirmation_menu_apply.disabled = true if identical_buttons.size() > 0 else false

func _update_input_button_color(button: Button, color: COLOR) -> void:
	match color:
		COLOR.WHITE:
			button.add_theme_color_override("font_color", Color(255.0, 255.0, 255.0))
			button.add_theme_color_override("font_pressed_color", Color(255.0, 255.0, 255.0))
			button.add_theme_color_override("font_hover_color", Color(255.0, 255.0, 255.0))
		COLOR.RED:
			button.add_theme_color_override("font_color", Color(255.0, 0.0, 0.0))
			button.add_theme_color_override("font_pressed_color", Color(255.0, 0.0, 0.0))
			button.add_theme_color_override("font_hover_color", Color(255.0, 0.0, 0.0))

func _set_options_to_option_file_values() -> void:
	var options: ConfigFile = OptionsManager.options_file
	var framerate_limit_value = options.get_value("display", "framerate_limit")

	window_mode_selector.selected = WINDOW_MODE_VALUES.find(options.get_value("display", "window_mode"))

	resolution_scale_slider.value = options.get_value("display", "resolution_scale")
	resolution_scale_percentage.text = "%s%%" % int(options.get_value("display", "resolution_scale") * 100)

	ui_scale_slider.value = options.get_value("display", "ui_scale")
	ui_scale_percentage.text = "%s%%" % int(options.get_value("display", "ui_scale") * 100)

	vsync_selector.selected = options.get_value("display", "vertical_syncronization")

	antialiasing_selector.selected = options.get_value("display", "antialiasing")

	framerate_limit_slider.value = 501 if framerate_limit_value == 0 else framerate_limit_value
	framerate_limit_number.text = "Unlimited" if framerate_limit_value == 0 else str(framerate_limit_value)

	move_forward_button.text = options.get_value("input", "move_forward").to_upper()
	move_left_button.text = options.get_value("input", "move_left").to_upper()
	move_backward_button.text = options.get_value("input", "move_backward").to_upper()
	move_right_button.text = options.get_value("input", "move_right").to_upper()

func _update_option(label: Label, key: String, subkey: String, value: Variant) -> void:
	if OptionsManager.options_file.get_value(key, subkey) == value:
		label.text = label.text.remove_char(KEY_ASTERISK)
		OptionsManager.options_buffer.erase(subkey)
	else:
		if !label.text.begins_with("*"): label.text = "*" + label.text
		OptionsManager.options_to_buffer(key, subkey, value)

func _apply_options() -> void:
	if input_buttons_overlap:
		print("Can not apply options")
	else:
		for label in option_labels:
			label.text = label.text.remove_char(KEY_ASTERISK)

		OptionsManager.save_options()
		OptionsManager.apply_display_options()
		OptionsManager.apply_input_options()

func _exit_options() -> void: Global.goto_last_menu(Global.REMOVE_CACHE)
