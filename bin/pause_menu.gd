class_name PauseMenu extends CanvasLayer

func _init() -> void:
	Global.connect("request_pause_menu", _show_pause_menu)

func _show_pause_menu() -> void:
	visible = true

func _on_exit_pressed() -> void:
	Global.emit_signal("request_main_menu")
