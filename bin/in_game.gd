class_name InGame extends Node

func _ready() -> void:
	var load_level: PackedScene = load("res://bin/levels/stage.tscn")
	add_child(load_level.instantiate())
