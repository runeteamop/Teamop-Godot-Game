extends Node

const UID: Dictionary = {
	"bullet": "uid://t8f0re2vibsy",
	"main_menu": "uid://dti63sqrcco35",
	"sub_menu": "uid://x3oqfrahoprv",
	"pause_menu": "uid://bualodl08ag0v",
	"runes_test": "uid://c46py3q0yqh4y",
	"enemy": "uid://bm3vdrvcbmk47"
}

var loaded_scenes: Dictionary = {}

var root: Root

func load_scene_into_memory(uid: String):
	if uid in loaded_scenes:
		push_error("'%s' is already in memory" % uid)
	else:
		loaded_scenes[uid] = load(uid).instantiate()
		
func free_scene_from_memory(uid: String):
	if !uid in loaded_scenes:
		push_error("'%s' is not in memory" % uid)
	else:
		loaded_scenes[uid].queue_free()
		loaded_scenes.erase(uid)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print(Global.loaded_scenes)
