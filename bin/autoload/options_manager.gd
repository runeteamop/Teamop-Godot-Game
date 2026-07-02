extends Node

const KEYS: Dictionary[String, Key] = {
	"a": KEY_A, "b": KEY_B, "c": KEY_C, "d": KEY_D, "e": KEY_E, "f": KEY_F,
	"g": KEY_G, "h": KEY_H, "i": KEY_I, "j": KEY_J, "k": KEY_K, "l": KEY_L,
	"m": KEY_M, "n": KEY_N, "o": KEY_O, "p": KEY_P, "q": KEY_Q, "r": KEY_R,
	"s": KEY_S, "t": KEY_T, "u": KEY_U, "v": KEY_V, "w": KEY_W, "x": KEY_X,
	"y": KEY_Y, "z": KEY_Z
}

const OPTIONS_PATH: String = "user://options.ini"

var options_buffer: Dictionary[String, Callable]

var options_file := ConfigFile.new()

func _init() -> void:
	if FileAccess.file_exists(OPTIONS_PATH):
		options_file.load(OPTIONS_PATH)
	else:
		options_file.set_value("display", "window_mode", 0)
		options_file.set_value("display", "resolution_scale", 1.0)
		options_file.set_value("display", "ui_scale", 1.0)
		options_file.set_value("display", "vertical_syncronization", 0)
		options_file.set_value("display", "antialiasing", 0)
		options_file.set_value("display", "framerate_limit", 0)

		options_file.set_value("input", "move_forward", "w")
		options_file.set_value("input", "move_left", "a")
		options_file.set_value("input", "move_backward", "s")
		options_file.set_value("input", "move_right", "d")

		options_file.set_value ("audio", "master_volume", 100)

		save_options()

func apply_display_options() -> void:
	DisplayServer.window_set_mode(options_file.get_value("display", "window_mode"))
	get_viewport().scaling_3d_scale = options_file.get_value("display", "resolution_scale")
	get_window().content_scale_factor = options_file.get_value("display", "ui_scale")
	DisplayServer.window_set_vsync_mode(options_file.get_value("display", "vertical_syncronization"))
	RenderingServer.viewport_set_msaa_3d(get_viewport().get_viewport_rid(), options_file.get_value("display", "antialiasing"))
	Engine.set_max_fps(options_file.get_value("display", "framerate_limit"))

func apply_input_options() -> void:
	var input_actions: PackedStringArray = options_file.get_section_keys("input")

	for action in input_actions:
		var selected_action = InputMap.action_get_events(action)

		for key in selected_action:
			if key is InputEventKey:
				InputMap.action_erase_event(action, key)

		var input_event := InputEventKey.new()
		input_event.keycode = KEYS[options_file.get_value("input", action)]

		InputMap.action_add_event(action, input_event)

func options_to_buffer(key: String, subkey: String, value: Variant) -> void:
	options_buffer[subkey] = func() -> void: options_file.set_value(key, subkey, value)

func flush_buffer() -> void:
	options_buffer.clear()

func save_options() -> void:
	for entry in options_buffer:
		options_buffer[entry].call()

	options_file.save(OPTIONS_PATH)
	flush_buffer()
