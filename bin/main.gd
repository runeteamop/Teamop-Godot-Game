class_name Main extends Node

func _ready() -> void:
	Global.emit_signal("load_game_state", "res://bin/menus.tscn")
