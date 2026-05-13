extends Node

const OPTIONS: String = "user://options.cfg"

var options = ConfigFile.new()

func _init() -> void:
	if !FileAccess.file_exists(OPTIONS):
		options.set_value("window", "window_mode", 4)
		options.set_value("window", "resolution_scale", 1.0)

		options.save(OPTIONS)
	else:
		options.load(OPTIONS)

	DisplayServer.window_set_mode(options.get_value("window", "window_mode"))

func window_mode() -> void:
	match options.get_value("window", "window_mode"):
		0:
			options.set_value("window", "window_mode", 4)
		4:
			options.set_value("window", "window_mode", 0)

	DisplayServer.window_set_mode(options.get_value("window", "window_mode"))
	save()

func save() -> void:
	options.save(OPTIONS)
