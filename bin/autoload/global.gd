extends Node

const UID: Dictionary = {
	"bullet": "uid://t8f0re2vibsy",
	"main_menu": "uid://dti63sqrcco35",
	"sub_menu": "uid://x3oqfrahoprv",
	"pause_menu": "uid://bualodl08ag0v",
	"runes_test": "uid://c46py3q0yqh4y",
	"enemy": "uid://bm3vdrvcbmk47"
}

var memory: Dictionary = {}

var root: Root

func load_scene_into_memory(uid: String) -> void:
	if uid in memory:
		push_error("'%s' is already in memory" % uid)
	else:
		memory[uid] = load(uid).instantiate()

func free_scene_from_memory(scene: Node = null, uid: String = "") -> void:
	#if !uid in memory:
		#push_error("'%s' is not in memory" % uid)
	#else:
		#memory[uid].queue_free()
		#memory.erase(uid)
	if scene:
		scene.queue_free()
		memory.erase(memory.find_key(scene))
	elif uid:
		memory[uid].queue_free()
		memory.erase(uid)

func flush_memory() -> void:
	for scenes: Node in memory.values():
		scenes.queue_free()
		memory.erase(memory.find_key(scenes))

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_cancel"):
		#print(memory)
