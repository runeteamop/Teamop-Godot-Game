extends Node

const OPTIONS_PATH: String = "user://options.ini"

var options_buffer: Dictionary

var options_file := ConfigFile.new()

func _init() -> void:
	if FileAccess.file_exists(OPTIONS_PATH):
		options_file.load(OPTIONS_PATH)
	else:
		options_file.set_value("display", "window_mode", 0)
		options_file.set_value("display", "resolusion_scale", 1.0)
		options_file.set_value("display", "resolusion_width", Vector2i(1920, 1080))

		options_file.set_value("graphics", "texture_resolusion", 1.0)
		options_file.set_value("graphics", "shadow_resolusion", 1.0)

		options_file.set_value("audio", "master_volume", 1.0)
		options_file.set_value("audio", "music_volume", 1.0)

		options_file.set_value("keybindings", "up", "w")
		options_file.set_value("keybindings", "left", "a")
		options_file.set_value("keybindings", "down", "s")
		options_file.set_value("keybindings", "right", "d")

		options_file.save(OPTIONS_PATH)

func display_settings_to_buffer(subkey: String, value: Variant) -> void:
	if !options_buffer.has("display"):
		options_buffer["display"] = {}

	options_buffer["display"][subkey] = value

func save_options() -> void:
	for entry in options_buffer:
		for subentry in options_buffer[entry]:
			options_file.set_value(entry, subentry, options_buffer[entry][subentry])

	options_file.save(OPTIONS_PATH)
	options_buffer.clear()

func apply_options(buffer: bool = false) -> void:
	DisplayServer.window_set_mode(options_file.get_value("display", "window_mode"))
	get_viewport().scaling_3d_scale = options_file.get_value("display", "resolusion_scale")
