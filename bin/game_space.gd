class_name GameSpace extends Root

func _init() -> void:
	world = self	
	ui = self
	
func add_scene_to_tree(uid: String):
	if !uid in Global.loaded_scenes:
		Global.load_scene_into_memory(uid)
		add_child(Global.loaded_scenes[uid])
	else:
		add_child(Global.loaded_scenes[uid])

func remove_scene_from_tree(uid: String):
	if !uid in Global.loaded_scenes:
		print("'%s' is not in memory" % uid)
	else:
		remove_child(Global.loaded_scenes[uid])
