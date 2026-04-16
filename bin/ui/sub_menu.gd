extends Control

func _on_button_pressed() -> void:
	Global.switch_scene.world(LOAD_SCENE.runes_test)
	queue_free()
