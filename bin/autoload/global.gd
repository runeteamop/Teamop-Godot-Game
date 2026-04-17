extends Node

var main: Main

var in_memory: Dictionary = {}

func load_into_memory(uid: String) -> void:
	if uid in in_memory:
		push_warning("Already in memory, dumbass.")
		
	var instantiated_scene: Node = load(uid).instantiate()
	
	in_memory[uid] = instantiated_scene

func remove_from_memory(scene: Object):
	scene.queue_free()
	in_memory.erase(scene)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print(in_memory)
