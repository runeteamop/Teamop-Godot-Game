class_name Main extends Node

@export var main_menu: MainMenu
@export var pause_menu: PauseMenu
@export var options: Options

@export var background: TextureRect

var in_game: InGame = null

func _init() -> void:
	Global.connect("toggle_level", _on_toggle_level)
	Global.connect("toggle_background", _on_toggle_background)
	Global.connect("toggle_main_menu", _on_toggle_main_menu)
	Global.connect("toggle_pause_menu", _on_toggle_pause_menu)
	Global.connect("toggle_options", _on_toggle_options)

func _on_toggle_level() -> void:
	background.visible = !background.visible
	if in_game:
		in_game.queue_free()
	else:
		in_game = load("res://bin/in_game.tscn").instantiate()
		add_child(in_game)

func _on_toggle_background() -> void:
	background.visible = !background.visible

func _on_toggle_main_menu() -> void:
	main_menu.visible = !main_menu.visible

func _on_toggle_pause_menu() -> void:
	pause_menu.visible = !pause_menu.visible

func _on_toggle_options(entered_from: Global.ENTERED_FROM) -> void:
	options.entered_from = entered_from
	options.visible = !options.visible
