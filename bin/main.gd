class_name Main extends Node

func _ready() -> void:
	OptionsManager.apply_display_options()
	OptionsManager.apply_input_options()
	Global.enter_game_state("res://bin/menus.tscn")
	#if OptionsManager.options_file.get_value("display", "window_mode") == 0:
		#get_window().set_size(DisplayServer.screen_get_size() / 1.25)
