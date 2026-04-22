class_name GameSpace extends Root

func _init() -> void:
	world = self
	ui = self

func add_scene(uid: String):
	if !uid in Global.memory:
		Global.load_into_memory(uid)
		add_child(Global.memory[uid])
		current_scenes[uid] = Global.memory[uid]
	else:
		add_child(Global.memory[uid])

func remove_scene(uid: String):
	if !uid in Global.memory:
		print("'%s' is not in memory" % uid)
	else:
		remove_child(current_scenes[uid])
		current_scenes.erase(uid)
