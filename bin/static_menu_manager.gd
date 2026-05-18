class_name StaticMenuManager extends CanvasLayer

var cache: Dictionary[String, Control]
var menu_stack: Array[Control]
var current_menu: Control

func _init() -> void:
	Global.connect("enter_menu", _on_enter_menu)
	Global.connect("goto_last_menu", _on_goto_last_menu)
	Global.connect("flush_menu_stack", _on_flush_menu_stack)

func _on_enter_menu(path: String) -> void:
	#if current_menu:
		#remove_child(current_menu)
	if menu_stack.size() > 0:
		for menu in menu_stack:
			menu.position.x -= current_menu.size.x

	if !path in cache:
		cache[path] = load(path).instantiate()

	current_menu = cache[path]
	add_child(current_menu)
	menu_stack.append(current_menu)

func _on_goto_last_menu() -> void:
	remove_child(current_menu)
	menu_stack.pop_back()

	if menu_stack.size() > 0:
		for menu in menu_stack:
			menu.position.x += current_menu.size.x

		current_menu = menu_stack[-1]
		#add_child(current_menu)
	else:
		current_menu = null

func _on_flush_menu_stack() -> void:
	remove_child(current_menu)
	current_menu = null
	menu_stack.clear()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_on_goto_last_menu()
