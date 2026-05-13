class_name StaticMenuManager extends CanvasLayer

var cache: Dictionary[String, Control]
var stack: Array[Control]
var current_menu: Control

func _init() -> void:
	Global.connect("enter_menu", _on_enter_menu)
	Global.connect("goto_last_menu", _on_goto_last_menu)
	Global.connect("flush_menu_stack", _on_flush_menu_stack)

func _on_enter_menu(path: String) -> void:
	if current_menu:
		remove_child(current_menu)

	if !path in cache:
		cache[path] = load(path).instantiate()

	current_menu = cache[path]
	add_child(current_menu)
	stack.append(current_menu)

func _on_goto_last_menu() -> void:
	remove_child(current_menu)
	stack.pop_back()

	current_menu = stack[-1]
	add_child(current_menu)

func _on_flush_menu_stack() -> void:
	remove_child(current_menu)
	current_menu = null
	stack.clear()
