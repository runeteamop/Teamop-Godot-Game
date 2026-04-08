class_name Menu extends Control

func _on_start_pressed() -> void:
	SCENE_MANAGER.change_scene(SCENE_MANAGER.sub_menu)

func _on_quit_pressed() -> void:
	get_tree().quit()
