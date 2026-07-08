class_name GameStateManager extends Node

var current_game_state: Node

func _init() -> void:
	Global.signal_request_game_state.connect(_on_request_game_state)

func _on_request_game_state(file_path: String) -> void:
	if current_game_state:
		current_game_state.queue_free()

	var load_file_path: PackedScene = load(file_path)
	current_game_state = load_file_path.instantiate()
	add_child(current_game_state)
