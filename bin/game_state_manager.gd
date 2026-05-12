class_name GameStateManager extends Node

@export var game_states: Array[String]

var current_game_state: Node

func _init() -> void:
	Global.connect("load_game_state", _on_load_game_state)

func _on_load_game_state(requested_game_state: String) -> void:
	if !requested_game_state in game_states:
		return push_error("\"%s\" is not a game state." % requested_game_state)

	Global.emit_signal("flush_menu_stack")

	if current_game_state:
		current_game_state.queue_free()

	current_game_state = load(requested_game_state).instantiate()
	add_child(current_game_state)
