class_name Root extends Node

@export var world: GameSpace
@export var ui: GameSpace

func _init() -> void:
	Global.root = self

func flush_scenes() -> void:
	world.flush_scenes()
	ui.flush_scenes()
