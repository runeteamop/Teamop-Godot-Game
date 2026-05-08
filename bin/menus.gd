class_name Menus extends Control

func _init() -> void:
	Global.connect("toggle_options_visibility", _on_toggle_options_visibility)

func _on_toggle_options_visibility(origin: Control) -> void:
	origin.visible = !origin.visible
