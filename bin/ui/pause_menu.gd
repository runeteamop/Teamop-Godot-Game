class_name PauseMenu extends Control

func _on_exit_pressed() -> void:
	pass

func _on_options_pressed() -> void:
	Global.emit_signal("enter_menu", "res://bin/ui/options.tscn")
