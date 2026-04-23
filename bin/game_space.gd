class_name GameSpace extends Root

func _init() -> void:
	world = self
	ui = self

func add_scene(uid: String) -> void:
	if uid in Global.memory:
		add_child(Global.memory[uid])
	else:
		Global.load_scene_into_memory(uid)
		add_child(Global.memory[uid])

func remove_scene(uid: String) -> void:
	remove_child(get_node(uid))

func flush_scenes() -> void:
	var children: Array = self.get_children()
	for child in children:
		remove_child(child)
