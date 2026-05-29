extends Node

const OPTIONS_PATH: String = "user://options.tres"

#var options_buffer: Dictionary

var options_file: Resource = Options.new()

func _init() -> void:
	if ResourceLoader.exists(OPTIONS_PATH):
		options_file = ResourceLoader.load(OPTIONS_PATH)
	else:
		save_options()

func apply_options() -> void:
	DisplayServer.window_set_mode(options_file.window_mode)
	get_viewport().scaling_3d_scale = options_file.resolusion_scale

func save_options() -> void: ResourceSaver.save(options_file, OPTIONS_PATH)

#func display_options_to_buffer(subkey: String, value: Variant) -> void:
	#if !options_buffer.has("display"):
		#options_buffer["display"] = {}
#
	#options_buffer["display"][subkey] = value
#
#func save_options() -> void:
	#for entry in options_buffer:
		#for subentry in options_buffer[entry]:
			#options_file.set_value(entry, subentry, options_buffer[entry][subentry])
#
	#options_file.save(OPTIONS_PATH)
	#options_buffer.clear()

#func apply_options(buffer: bool = false) -> void:
	#DisplayServer.window_set_mode(options_file.get_value("display", "window_mode"))
	#get_viewport().scaling_3d_scale = options_file.get_value("display", "resolusion_scale")
