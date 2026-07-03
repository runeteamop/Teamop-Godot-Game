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
# placeholder
# placeholder

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

	default_menu_back.pressed.connect(_on_default_menu_back_pressed)
	default_menu_apply.pressed.connect(_on_default_menu_apply_pressed)

	display_tab.pressed.connect(_on_display_tab_pressed)
	audio_tab.pressed.connect(_on_audio_tab_pressed)
	input_tab.pressed.connect(_on_input_tab_pressed)

	confirmation_menu_return.pressed.connect(_on_confirmation_menu_return_pressed)
	confirmation_menu_discard.pressed.connect(_on_confirmation_menu_discard_pressed)
	confirmation_menu_apply.pressed.connect(_on_confirmation_menu_apply_pressed)

	window_mode_selector.item_selected.connect(_on_window_mode_selector_item_selected)
	resolution_scale_slider.value_changed.connect(_on_resolution_scale_slider_value_changed)
	ui_scale_slider.value_changed.connect(_on_ui_scale_slider_value_changed)
	vsync_selector.item_selected.connect(_on_v_sync_selector_item_selected)
	antialiasing_selector.item_selected.connect(_on_antialiasing_selector_item_selected)
	framerate_limit_slider.value_changed.connect(_on_framerate_limit_slider_value_changed)

	move_forward_button.toggled.connect(_on_input_button_toggled.bind(move_forward_button, move_forward_label, "move_forward"), 3)
	move_left_button.toggled.connect(_on_input_button_toggled.bind(move_left_button, move_left_label, "move_left"), 3)
	move_backward_button.toggled.connect(_on_input_button_toggled.bind(move_backward_button, move_backward_label, "move_backward"), 3)
	move_right_button.toggled.connect(_on_input_button_toggled.bind(move_right_button, move_right_label, "move_right"), 3)

# Called when a corresponding node is handled:
func _on_default_menu_back_pressed() -> void:
	if OptionsManager.options_buffer.size() > 0:
		_swap_bottom_panel_buttons(bottom_panel_confirmation_menu)
	else:
		_exit_options()

func _on_default_menu_apply_pressed() -> void:
	if current_input_button_toggled: _disable_toggled_input_button()
	_apply_options()
	_remove_asterisk_from_labels()

func _on_display_tab_pressed() -> void:
	_swap_current_menu(display_option_menu)

func _on_audio_tab_pressed() -> void:
	_swap_current_menu(audio_option_menu)

func _on_input_tab_pressed() -> void:
	_swap_current_menu(input_option_menu)

func _on_confirmation_menu_return_pressed() -> void:
	_swap_bottom_panel_buttons(bottom_panel_default_menu)

func _on_confirmation_menu_discard_pressed() -> void:
	OptionsManager.flush_buffer()
	_exit_options()

func _on_confirmation_menu_apply_pressed() -> void:
	if current_input_button_toggled: _disable_toggled_input_button()
	_apply_options()
	_exit_options()

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

func _on_input_button_toggled(toggled_on: bool, button: Button, label: Label, subkey: String) -> void:
	_update_input_button_text(toggled_on, button, label, subkey)
	set_process_unhandled_input(toggled_on)

# Swap functions for bottom panel & option menu
func _swap_bottom_panel_buttons(new_bar: HBoxContainer) -> void:
	current_bottom_bar.visible = false
	new_bar.visible = true
	current_bottom_bar = new_bar

func _swap_current_menu(new_menu: PanelContainer)-> void:
	if current_menu == input_option_menu: _disable_toggled_input_button()
	current_menu.visible = false
	new_menu.visible = true
	current_menu = new_menu

func _update_option(label: Label, key: String, subkey: String, value: Variant) -> void:
	if OptionsManager.options_file.get_value(key, subkey) == value:
		label.text = label.text.remove_char(KEY_ASTERISK)
		OptionsManager.options_buffer.erase(subkey)
	else:
		if !label.text.begins_with("*"): label.text = "*" + label.text
		OptionsManager.options_to_buffer(key, subkey, value)

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

func _remove_asterisk_from_labels() -> void:
	for label in option_labels:
		label.text = label.text.remove_char(KEY_ASTERISK)

func _update_input_button_text(toggled_on: bool, button: Button, label: Label, subkey: String) -> void:
	if !toggled_on:
		#button.text = input_button_label_buffer
		_update_option(label, "input", subkey, button.text.to_lower())
	else:
		if current_input_button_toggled != button: input_button_label_buffer = button.text
		button.text = "Awaiting input..."
		current_input_button_toggled = button
		_update_input_button_color(button, COLOR.WHITE)

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

func _disable_toggled_input_button() -> void:
	current_input_button_toggled.button_pressed = false

func _unhandled_input(event: InputEvent) -> void:
	var event_text = event.as_text()

	var button_overlap_checker: Callable = func() -> void:
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

		input_buttons_overlap = true if identical_buttons.size() > 0 else false

	if event.keycode == KEY_ESCAPE:
			current_input_button_toggled.text = input_button_label_buffer
			_disable_toggled_input_button()
			button_overlap_checker.call()
	elif OptionsManager.KEYS.has(event_text.to_lower()):
		current_input_button_toggled.text = event_text
		input_button_label_buffer = event_text
		button_overlap_checker.call()
		_disable_toggled_input_button()
	else:
		print("Input not accepted")

func _apply_options() -> void:
	OptionsManager.save_options()
	OptionsManager.apply_display_options()
	OptionsManager.apply_input_options()

func _exit_options() -> void: Global.goto_last_menu(Global.REMOVE_CACHE)

#func _deactivate_active_button(text: String = active_input_button_old_text) -> void:
	#active_input_button.text = text
	#active_input_button.button_pressed = false
	#active_input_button = null
	#active_input_button_old_text = ""
#
#func _get_pressed_input_button(toggled_on: bool) -> void:
	#if toggled_on:
		## If a button is already active, the button text gets set to the value of
		## "active_input_button".
		#if active_input_button:
			#_deactivate_active_button()
			##_swap_await_message_with_input()
#
		## Sets the "active_input_button" variable to the currently selected button,
		## and grabs its text before it is changed to "Awaiting input...".
		#for button in input_button_group:
			#if button.button_pressed:
				#active_input_button = button
				#active_input_button_old_text = button.text
				#button.text = "Awaiting input..."
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.pressed:
		#print(event.as_text())
	##if event.pressed:
		##match event.keycode:
			##KEY_ESCAPE:
				##_deactivate_active_button()
			##_:
				##var event_lower_case: String = event.as_text().to_lower()
##
				##if event is InputEventKey && event_lower_case in OptionsManager.KEYS:
					##for button in input_button_group:
						##if button.text == event.as_text():
							##_option_changed_checker(indicators[button.get_meta("index")], "input",
							##button.get_meta("action"), active_input_button_old_text.to_lower())
							##button.text = active_input_button_old_text
##
				##_option_changed_checker(indicators[active_input_button.get_meta("index")], "input",
				##active_input_button.get_meta("action"), event_lower_case)
##
				### Deactivates the selected button, sets the buttons text to the pressed key,
				### and flushes its associated variables.
				##_deactivate_active_button(event.as_text())
