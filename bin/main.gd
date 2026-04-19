class_name Main extends Node

@export var world_node: Node3D
@export var ui_node: Control

var in_memory: Dictionary = {}
var current_world_scene: Node3D
var current_ui_scene: Control

func _init() -> void:
	Global.main = self
	
func _ready() -> void:
	current_ui_scene = $UI/MainMenu
	in_memory[LOAD_SCENE.main_menu] = current_ui_scene

#func load_into_memory(uid: String) -> void:
	#if uid in in_memory:
		#push_warning("Already in memory: %s" % in_memory[uid])
	#else:
		#var instantiated_scene: Node = load(uid).instantiate()
		#in_memory[uid] = instantiated_scene
#
#func remove_from_memory(uid: String) -> void:
	#if !uid in in_memory:
		#push_error("Not in memory: %s" % uid)
	#else:
		#in_memory[uid].queue_free()
		#in_memory.erase(uid)
#
#func switch_scene(uid: String) -> void:
	#if !uid in in_memory:
		#push_error("Not in memory: %s" % uid)
	#elif in_memory[uid].get_class() == "Node3D":
		#if current_world_scene:
			#world_node.remove_child(current_world_scene)
		#
		#world_node.add_child(in_memory[uid])
		#current_world_scene = in_memory[uid]
	#elif in_memory[uid].get_class() == "Control":
		#if current_ui_scene:
			#ui_node.remove_child(current_ui_scene)
		#
		#ui_node.add_child(in_memory[uid])
		#current_ui_scene = in_memory[uid]
