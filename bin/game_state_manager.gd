class_name GameStateManager extends Node

@export var background: TextureRect

var in_game: InGame

func _init() -> void:
	Global.connect("switch_game_state", _on_switch_game_state)

func _on_switch_game_state() -> void:
	background.visible = !background.visible

	if in_game:
		in_game.queue_free()
	else:
		in_game = load("res://bin/in_game.tscn").instantiate()
		add_child(in_game)
