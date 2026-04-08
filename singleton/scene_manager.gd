extends Node

var current_scene: Node

<<<<<<< HEAD
var main_menu: String = "uid://cdwkb8h2hb2wy"
var	sub_menu: String = "uid://dmg2j14j7w1eb"

=======
>>>>>>> movement
func change_scene(scene: String) -> void:
	if current_scene != null:
		remove_child(current_scene)
	
	var instantiated_scene: Node = load(scene).instantiate()
	
	add_child(instantiated_scene)
	current_scene = instantiated_scene
