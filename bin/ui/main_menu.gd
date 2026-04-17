class_name MainMenu extends Control

func _ready() -> void:
	Global.load_into_memory(LOAD_SCENE.sub_menu)

func _on_start_pressed() -> void:
	Global.main.switch_scene(LOAD_SCENE.sub_menu)
