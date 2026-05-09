class_name MainMenu extends Control

func _on_singleplayer_pressed() -> void:
	Global.emit_signal("toggle_level")
	#Global.emit_signal("toggle_background")
	Global.emit_signal("toggle_main_menu")

func _on_options_pressed() -> void:
	Global.emit_signal("toggle_options", Global.ENTERED_FROM.MAIN_MENU)
	Global.emit_signal("toggle_main_menu")


func _on_exit_game_pressed() -> void:
	get_tree().quit()
