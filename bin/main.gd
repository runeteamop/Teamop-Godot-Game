class_name Main extends Node

@export var world_node: Node3D
@export var ui_node: Control

var current_world_scene: Node3D
var current_ui_scene: Control

func _init() -> void:
	Global.switch_scene = self

func _ready() -> void:
	current_ui_scene = $UI/MainMenu

func world(world_scene: String) -> void:
	var new_world_scene: Node3D = load(world_scene).instantiate()

	if current_world_scene:
		current_world_scene.queue_free()

	current_world_scene = new_world_scene

	world_node.add_child(new_world_scene)

func ui(ui_scene: String) -> void:
	var new_ui_scene: Control = load(ui_scene).instantiate()

	if current_ui_scene:
		current_ui_scene.queue_free()

	current_ui_scene = new_ui_scene

	ui_node.add_child(new_ui_scene)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print(get_tree_string_pretty())
