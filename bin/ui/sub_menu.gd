extends Control

func _on_button_pressed() -> void:
	Global.load_into_memory(LOAD_SCENE.runes_test)
	Global.main.switch_scene(LOAD_SCENE.runes_test)
	Global.remove_from_memory(self)
