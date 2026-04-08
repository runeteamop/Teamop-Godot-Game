class_name Menu extends Control

func _on_start_pressed() -> void:
<<<<<<< HEAD
	SCENE_MANAGER.change_scene(SCENE_MANAGER.sub_menu)
=======
	SCENE_MANAGER.change_scene(LOAD_SCENE.sub_menu)
>>>>>>> movement

func _on_quit_pressed() -> void:
	get_tree().quit()
