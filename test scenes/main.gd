extends Node

@onready var Main_Menu = preload("res://test scenes/pause_menu.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(Main_Menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
