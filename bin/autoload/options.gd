extends Node

const OPTIONS_PATH: String = "user://options.cfg"

var options = ConfigFile.new()

func _init() -> void:
	if FileAccess.file_exists(OPTIONS_PATH):
		options.load(OPTIONS_PATH)
	else:
		options.set_value("display", "fullscreen", false)
		options.set_value("display", "resolusion_scale", 3)
		options.set_value("display", "resolusion", "1920x1080")

		options.set_value("graphics", "texture_resolusion", 1.0)
		options.set_value("graphics", "shadow_resolusion", 1.0)

		options.set_value("audio", "master_volume", 1.0)
		options.set_value("audio", "music_volume", 1.0)

		options.set_value("keybindings", "up", "w")
		options.set_value("keybindings", "left", "a")
		options.set_value("keybindings", "down", "s")
		options.set_value("keybindings", "right", "d")

		options.save(OPTIONS_PATH)

func save(section: String, key: String, value) -> void:
	options.set_value(section, key, value)
	options.save(OPTIONS_PATH)

func load_options_as_dictionary() -> Dictionary[String, Variant]:
	var option_values: Dictionary[String, Variant] = {}
	var sections: PackedStringArray = options.get_sections()

	for section in sections:
		var keys: PackedStringArray = options.get_section_keys(section)

		for key in keys:
			option_values[key] = options.get_value(section, key)

	return option_values

func apply() -> void:
	var option_values: Dictionary[String, Variant] = load_options_as_dictionary()

	if option_values.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	match option_values.resolusion_scale:
		0:
			get_window().scaling_3d_scale = 0.125
		1:
			get_window().scaling_3d_scale = 0.25
		2:
			get_window().scaling_3d_scale = 0.5
		3:
			get_window().scaling_3d_scale = 1.0
		4:
			get_window().scaling_3d_scale = 2.0
		5:
			get_window().scaling_3d_scale = 4.0
