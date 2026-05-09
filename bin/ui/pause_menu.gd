class_name PauseMenu extends Control

func _on_exit_pressed() -> void:
	Global.emit_signal("toggle_level")
	Global.emit_signal("toggle_main_menu")
	Global.emit_signal("toggle_pause_menu")
	get_tree().paused = false


func _on_options_pressed() -> void:
	Global.emit_signal("toggle_pause_menu")
	Global.emit_signal("toggle_options", Global.ENTERED_FROM.PAUSE_MENU)
