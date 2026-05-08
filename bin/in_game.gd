extends Node

func _init() -> void:
	Global.connect("request_main_menu", _exit_level)

func _ready() -> void:
	add_child(load("res://bin/levels/asgers_test.tscn").instantiate())

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Global.emit_signal("request_pause_menu", self)

func _exit_level() -> void:
	queue_free()
