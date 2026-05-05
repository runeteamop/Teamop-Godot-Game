class_name Options extends Control

var entered_from: Node = null

func _on_back_pressed() -> void:
	visible = false
	entered_from.visible = true
