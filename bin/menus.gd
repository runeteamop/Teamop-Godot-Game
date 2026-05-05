class_name Menus extends Node

@export var main_menu: MainMenu
@export var options: Options

func _init() -> void:
	Global.connect("request_options", _show_options)
	Global.connect("request_main_menu", _show_main_menu)

func _show_options(origin: Node) -> void:
	origin.visible = false
	options.visible = true
	options.entered_from = origin

func _show_main_menu() -> void:
	main_menu.visible = true
