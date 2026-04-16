class_name MainMenu extends Control

func _on_start_pressed() -> void:
	Global.switch_scene.ui(LOAD_SCENE.sub_menu)
