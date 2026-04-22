extends Control

func _on_button_pressed() -> void:
	Global.root.flush_scenes()
