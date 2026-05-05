extends Node

func _init() -> void:
	Global.connect("request_main_menu", _exit_level)

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Global.emit_signal("request_pause_menu")

func _exit_level() -> void:
	queue_free()
