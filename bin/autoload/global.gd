extends Node

signal request_game_state(file_path: String)
signal enter_menu(file_path: String)
signal goto_last_menu
signal flush_menu_stack

func enter_game_state(file_path: String) -> void:
	emit_signal("flush_menu_stack")
	emit_signal("request_game_state", file_path)
	get_tree().paused = false

func emit_request_game_state(file_path: String) -> void: request_game_state.emit(file_path)

func emit_enter_menu(file_path: String) -> void: enter_menu.emit(file_path)

func emit_goto_last_menu(file_path: String) -> void: goto_last_menu.emit(file_path)

func emit_flush_menu_stack(file_path: String) -> void: flush_menu_stack.emit(file_path)
