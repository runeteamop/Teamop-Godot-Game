class_name SubMenu extends Control

func _on_back_pressed() -> void:
	SCENE_MANAGER.change_scene(SCENE_MANAGER.main_menu)
