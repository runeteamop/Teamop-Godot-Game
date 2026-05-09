class_name Options extends Control

var entered_from: int

func _on_back_pressed() -> void:
	match entered_from:
		Global.ENTERED_FROM.MAIN_MENU:
			Global.emit_signal("toggle_main_menu")
		Global.ENTERED_FROM.PAUSE_MENU:
			Global.emit_signal("toggle_pause_menu")
	visible = false
