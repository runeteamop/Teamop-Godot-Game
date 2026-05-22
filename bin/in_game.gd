class_name InGame extends Node

func _ready() -> void:
	add_child(load("res://bin/levels/stage.tscn").instantiate())
