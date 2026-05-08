class_name MainMenu extends Control

func _on_singleplayer_pressed() -> void:
	Global.emit_signal("request_level")

func _on_multiplayer_pressed() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	Global.emit_signal("toggle_options_visibility", self)

func _on_exit_game_pressed() -> void:
	get_tree().quit()
