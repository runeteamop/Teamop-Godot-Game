class_name MainMenu extends Control

func _ready() -> void:
	Global.memory[Global.UID.main_menu] = self

func _on_start_pressed() -> void:
	Global.root.ui.add_scene(Global.UID.sub_menu)
	Global.root.ui.remove_child(self)
