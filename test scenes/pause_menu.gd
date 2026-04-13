extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") && !get_tree().paused:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		show()
	elif Input.is_action_just_pressed("ui_cancel") && get_tree().paused:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		get_tree().paused = false
		
