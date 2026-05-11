class_name StaticMenuManager extends CanvasLayer

var menus: Dictionary[String, Control] = {
	"res://bin/ui/main_menu.tscn": load("res://bin/ui/main_menu.tscn").instantiate(),
	"res://bin/ui/pause_menu.tscn": load("res://bin/ui/pause_menu.tscn").instantiate(),
	"res://bin/ui/options.tscn": load("res://bin/ui/options.tscn").instantiate()
}

@export var stack: Array[Control]
@export var current_menu: Control

func _init() -> void:
	Global.connect("enter_menu", _on_enter_menu)
	Global.connect("go_back", _on_go_back)
	Global.connect("flush_menu_stack", _on_flush_menu_stack)

func _on_enter_menu(desired_menu: String) -> void:
	if !desired_menu in menus:
		return push_error("\"%s\" is not a menu." % desired_menu)

	if current_menu:
		remove_child(current_menu)

	add_child(menus[desired_menu])
	current_menu = menus[desired_menu]

	stack.append(current_menu)

func _on_go_back() -> void:
	if current_menu:
		remove_child(current_menu)
		stack.pop_back()

	current_menu = stack[-1]
	add_child(current_menu)

func _on_flush_menu_stack() -> void:
	stack.clear()

	remove_child(current_menu)
	current_menu = null
