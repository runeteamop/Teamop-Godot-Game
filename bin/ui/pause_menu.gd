extends Control

func _ready() -> void:
	Global.root.ui.remove_child(self)

func _on_button_pressed() -> void:
	Global.root.flush_scenes()
