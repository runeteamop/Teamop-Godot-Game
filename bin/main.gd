class_name Main extends Node

func _ready() -> void:
	OptionsManager.apply_all_options()
	Global.enter_game_state("res://bin/menus.tscn")
