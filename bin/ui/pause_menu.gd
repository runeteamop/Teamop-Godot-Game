class_name PauseMenu extends Control

func _on_exit_pressed() -> void:
	RuntimeManager.toggle_runtime()
	Global.emit_signal("load_game_state", "res://bin/menus.tscn")

func _on_options_pressed() -> void:
	Global.emit_signal("enter_menu", "res://bin/ui/options.tscn")
