extends Node

var current_scene: Node

func change_scene(scene: String) -> void:
	if current_scene != null:
		remove_child(current_scene)
	
	var instantiated_scene: Node = load(scene).instantiate()
	
	add_child(instantiated_scene)
	current_scene = instantiated_scene
