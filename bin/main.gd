class_name Main extends Node

func _ready() -> void:
	Options.apply()
	Global.enter_game_state("res://bin/menus.tscn")
