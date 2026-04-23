extends Control

func _on_button_pressed() -> void:
	Global.root.world.add_scene(Global.UID.runes_test)
	Global.root.ui.remove_child(self)
