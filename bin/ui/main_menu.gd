class_name MainMenu extends Control

func _on_singleplayer_pressed() -> void:
	Global.emit_signal("load_game_state", "res://bin/in_game.tscn")

func _on_options_pressed() -> void:
	Global.emit_signal("enter_menu", "res://bin/ui/options.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()
