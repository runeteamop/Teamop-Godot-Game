class_name MainMenu extends Control

func _on_singleplayer_pressed() -> void:
	visible = false
	Global.emit_signal("request_level", 1)

func _on_options_pressed() -> void:
	Global.emit_signal("request_options", self)

func _on_exit_game_pressed() -> void:
	get_tree().quit(0)
