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
		options_file.set_value("display", "vertical_syncronization", 0)
		options_file.set_value("display", "antialiasing", 0)
		options_file.set_value("display", "framerate_limit", 0)

		options_file.set_value("input", "forward", "w")
		options_file.set_value("input", "left", "a")
		options_file.set_value("input", "backward", "s")
		options_file.set_value("input", "right", "d")

		options_file.set_value ("audio", "master_volume", 100)


		save_options()

func apply_all_options() -> void:
	DisplayServer.window_set_mode(options_file.get_value("display", "window_mode"))
	get_viewport().scaling_3d_scale = options_file.get_value("display", "resolution_scale")
	get_window().content_scale_factor = options_file.get_value("display", "ui_scale")
	DisplayServer.window_set_vsync_mode(options_file.get_value("display", "vertical_syncronization"))
	RenderingServer.viewport_set_msaa_3d(get_viewport().get_viewport_rid(), options_file.get_value("display", "antialiasing"))
	Engine.set_max_fps(options_file.get_value("display", "framerate_limit"))

func options_to_buffer(key: String, subkey: String, value: Variant) -> void:
	options_buffer[subkey] = func() -> void: options_file.set_value(key, subkey, value)

func flush_buffer() -> void:
	options_buffer.clear()

func save_options() -> void:
	for entry in options_buffer:
		options_buffer[entry].call()

	options_file.save(OPTIONS_PATH)
	flush_buffer()
