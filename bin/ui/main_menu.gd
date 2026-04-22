class_name MainMenu extends Control

func _ready() -> void:
	Global.memory[Global.UID.main_menu] = self
	Global.root.current_scenes[Global.UID.main_menu] = self
	#Global.root.current_scenes[Global.UID.main_menu] = self
func _on_start_pressed() -> void:
	Global.root.world.add_scene(Global.UID.runes_test)
	Global.root.ui.remove_scene(self)
	#Global.root.ui.add_scene(Global.UID.sub_menu)
	#Global.root.ui.remove_scene(Global.UID.main_menu)
