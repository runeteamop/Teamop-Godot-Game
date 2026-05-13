extends Node

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var runtime: bool = get_tree().paused

		if runtime:
			Global.emit_signal("flush_menu_stack")
		else:
			Global.emit_signal("enter_menu", "res://bin/ui/pause_menu.tscn")

		get_tree().paused = !runtime
