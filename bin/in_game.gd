class_name InGame extends Node

func _ready() -> void:
	add_child(load("res://bin/levels/asgers_test.tscn").instantiate())

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Global.emit_signal("toggle_pause_menu")
		get_tree().paused = !get_tree().paused
