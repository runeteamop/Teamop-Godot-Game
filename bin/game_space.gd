class_name GameSpace extends Root

func _init() -> void:
	world = self
	ui = self

func add_scene(uid: String) -> void:
	if uid in Global.memory:
		current_scenes[uid] = Global.memory[uid]
		add_child(current_scenes[uid])
	else:
		Global.load_scene_into_memory(uid)
		current_scenes[uid] = Global.memory[uid]
		add_child(current_scenes[uid])


func remove_scene(scene: Node = null, uid: String = "") -> void:
	#if !uid in Global.memory:
		#print("'%s' is not in memory" % uid)
	#else:
		#remove_child(current_scenes[uid])
		#current_scenes.erase(uid)
	if scene:
		remove_child(scene)
		current_scenes.erase(current_scenes.find_key(scene))
	elif uid:
		remove_child(current_scenes[uid])
		current_scenes.erase(uid)
