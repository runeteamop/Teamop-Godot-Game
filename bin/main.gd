class_name Main extends Node

@export var world_node: Node3D
@export var ui_node: Control

@onready var in_memory := Global.in_memory

var current_world_scene: Node3D
var current_ui_scene: Control

func _init() -> void:
	Global.main = self

func _ready() -> void:
	current_ui_scene = $UI/MainMenu
	Global.in_memory[LOAD_SCENE.main_menu] = current_ui_scene

func switch_scene(uid: String) -> void:
	if !uid in in_memory:
		push_error("Not in memory, dumbass.")
	elif in_memory[uid].get_class() == "Control":
		if current_ui_scene:
			ui_node.remove_child(current_ui_scene)
		
		ui_node.add_child(in_memory[uid]) 
	
		current_ui_scene = in_memory[uid]
	elif in_memory[uid].get_class() == "Node3D":
		if current_world_scene:
			world_node.remove_child(current_ui_scene)
		
		world_node.add_child(in_memory[uid])

		current_world_scene = in_memory[uid]
