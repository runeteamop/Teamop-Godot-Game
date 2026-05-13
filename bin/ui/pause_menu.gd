class_name PauseMenu extends Control

func _on_exit_pressed() -> void:
	Global.enter_game_state("res://bin/menus.tscn")

func _on_options_pressed() -> void:
	Global.emit_signal("enter_menu", "res://bin/ui/options_menu.tscn")
