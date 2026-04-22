class_name Root extends Node

@export var world: GameSpace
@export var ui: GameSpace

static var current_scenes: Dictionary = {}

func _init() -> void:
	Global.root = self

func flush_scenes():
	var game_scope: Array = find_children("*")
	for scene: GameSpace in game_scope:
		for children in scene.get_children():
			scene.remove_child(scene.get_child(0))
