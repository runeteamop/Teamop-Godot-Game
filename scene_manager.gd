class_name SceneManager extends Node

var current_scene: Node
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(scene: String) -> void:
	if current_scene != null:
		remove_child(current_scene)
	
	var instantiated_scene: Node = load(scene).instantiate()
	
	add_child(instantiated_scene)
	current_scene = instantiated_scene
