class_name Main extends Node

func _ready() -> void:
	Global.enter_game_state("res://bin/menus.tscn")
	print(OS.get_data_dir())
