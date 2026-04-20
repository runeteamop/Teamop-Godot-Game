class_name MainMenu extends Control

func _ready() -> void:
	Global.loaded_scenes[Global.UID.main_menu] = self

func _on_start_pressed() -> void:
	Global.root.ui.add_scene_to_tree(Global.UID.sub_menu)
