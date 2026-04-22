class_name Root extends Node

@export var world: GameSpace
@export var ui: GameSpace

static var current_scenes: Dictionary = {}

func _init() -> void:
	Global.root = self

func flush_scenes():
	var world_children: Array = world.get_children()
	var ui_children: Array = ui.get_children()

	for scenes: Node in current_scenes.values():
		if scenes in world_children:
			world.remove_child(scenes)
			print("removed world")
		elif scenes in ui_children:
			ui.remove_child(scenes)
			print("removed ui")

		current_scenes.erase(current_scenes.find_key(scenes))
