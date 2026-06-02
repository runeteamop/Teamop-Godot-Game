class_name Main extends Node

func _ready() -> void:
	DisplayServer.window_set_size(DisplayServer.screen_get_size() * 0.9)
	OptionsManager.apply_all_options()
	Global.enter_game_state("res://bin/menus.tscn")
