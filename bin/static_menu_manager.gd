class_name StaticMenuManager extends CanvasLayer

var cache: Dictionary[String, Control]
var menu_stack: Array[Control]
var current_menu: Control

func _init() -> void:
	Global.signal_enter_menu.connect(_on_enter_menu)
	Global.signal_goto_last_menu.connect(_on_goto_last_menu)
	Global.signal_flush_menu_stack.connect(_on_flush_menu_stack)

func _on_enter_menu(path: String) -> void:
	if current_menu:
		remove_child(current_menu)

	if !path in cache:
		cache[path] = load(path).instantiate()

	current_menu = cache[path]
	add_child(current_menu)
	menu_stack.append(current_menu)

func _on_goto_last_menu() -> void:
	remove_child(current_menu)
	menu_stack.pop_back()

	if menu_stack.size() > 0:
		current_menu = menu_stack[-1]
		add_child(current_menu)
	else:
		current_menu = null

func _on_flush_menu_stack() -> void:
	if current_menu:
		remove_child(current_menu)
	current_menu = null
	menu_stack.clear()
