class_name Menus extends Node

@export var block: MeshInstance3D

func _ready() -> void:
	Global.enter_menu("res://bin/ui/main_menu.tscn")

func _process(delta: float) -> void:
	block.rotate(Vector3(1, 0, 0), 0.5 * delta)
	#block.rotate(Vector3(0, 1, 0), 0.5 * delta)
	block.rotate(Vector3(0, 0, 1), 0.5 * delta)
