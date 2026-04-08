class_name SubMenu extends Control

func _on_back_pressed() -> void:
	SCENE_MANAGER.change_scene(LOAD_SCENE.main_menu)
