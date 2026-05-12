class_name Menus extends Node

func _ready() -> void:
	Global.emit_signal("enter_menu", "res://bin/ui/main_menu.tscn")
