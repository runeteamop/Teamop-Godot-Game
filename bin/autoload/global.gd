extends Node


signal request_game_state(file_path: String)
@warning_ignore("unused_signal")
signal enter_menu(file_path: String)
@warning_ignore("unused_signal")
signal goto_last_menu
signal flush_menu_stack

func enter_game_state(file_path: String) -> void:
	emit_signal("flush_menu_stack")
	emit_signal("request_game_state", file_path)
	get_tree().paused = false
