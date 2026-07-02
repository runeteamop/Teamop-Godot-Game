extends Node

signal signal_request_game_state(file_path: String)
signal signal_enter_menu(file_path: String)
signal signal_goto_last_menu
signal signal_flush_menu_stack

enum {REMOVE_CACHE, KEEP_CACHE}

const REMOVE_FROM_CACHE: bool = true

func enter_game_state(file_path: String) -> void:
	signal_flush_menu_stack.emit()
	signal_request_game_state.emit(file_path)
	get_tree().paused = false

#func request_game_state(file_path: String) -> void: request_game_state.emit(file_path)
func enter_menu(file_path: String) -> void: signal_enter_menu.emit(file_path)
func goto_last_menu(handle_cache: bool) -> void: signal_goto_last_menu.emit(handle_cache)
func flush_menu_stack() -> void: signal_flush_menu_stack.emit()
