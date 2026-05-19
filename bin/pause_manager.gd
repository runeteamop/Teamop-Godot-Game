extends Node

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			Global.emit_signal("flush_menu_stack")
		else:
			Global.emit_signal("enter_menu", "res://bin/ui/pause_menu.tscn")

		RuntimeManager.toggle_runtime()
