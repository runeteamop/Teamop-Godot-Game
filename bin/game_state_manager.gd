class_name GameStateManager extends Node

var current_game_state: Node

func _init() -> void:
	Global.connect("request_game_state", _on_request_game_state)

func _on_request_game_state(file_path: String) -> void:
	if current_game_state:
		current_game_state.queue_free()

	current_game_state = load(file_path).instantiate()
	add_child(current_game_state)
