extends Node

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

		save_options()

func apply_all_options() -> void:
	DisplayServer.window_set_mode(options_file.get_value("display", "window_mode"))
	get_viewport().scaling_3d_scale = options_file.get_value("display", "resolution_scale")
	get_window().content_scale_factor = options_file.get_value("display", "ui_scale")

func options_to_buffer(key: String, subkey: String, value: Variant) -> void:
	options_buffer[subkey] = func() -> void: options_file.set_value(key, subkey, value)

func save_options() -> void:
	for entry in options_buffer:
		options_buffer[entry].call()

	options_file.save(OPTIONS_PATH)
	options_buffer.clear()
