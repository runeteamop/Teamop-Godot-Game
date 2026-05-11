class_name Options extends Control

func _on_back_pressed() -> void:
	Global.emit_signal("go_back")
