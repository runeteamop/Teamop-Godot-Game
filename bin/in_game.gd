class_name InGame extends Node

func _ready() -> void:
	Global.emit_signal("flush_menu_stack")
	add_child(load("res://bin/levels/asgers_test.tscn").instantiate())
