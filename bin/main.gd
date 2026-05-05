class_name Main extends Node

func _init() -> void:
	Global.connect("request_level", _enter_level)

func _ready() -> void:
	pass

func _enter_level(level) -> void:
	add_child(load("res://bin/in_game.tscn").instantiate())
