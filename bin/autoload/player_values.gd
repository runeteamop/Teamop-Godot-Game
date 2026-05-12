extends Node

signal upgrade_pause
signal xp_changed
signal dash_cooldown_changed

const STARTING_LEVELUP_THRESHOLD: int = 5
const XP_INCREASE_ON_LEVELUP: int = 2

var upgrades_folder: String = "res://bin/upgrade_resources/"
var all_upgrades: Array
var all_upgrade_uis: Array[Upgrade_UI]
var current_upgrades: Array
var overflow_of_upgrades: int = 0

var reload_speed = 0.5

var xp: float = 0:
	set(value):
		if xp != value:
			xp = value
			xp_changed.emit(xp)

var dash_cooldown: float = 0:
	set(value):
		if dash_cooldown != value:
			dash_cooldown = value
			dash_cooldown_changed.emit(value)

func _ready() -> void:
	all_upgrades = DirAccess.get_files_at(upgrades_folder)

func _level_up() -> void:
	if all_upgrade_uis.size() > 0:
		overflow_of_upgrades = floori(all_upgrade_uis.size()/3.0)
	var temp_upgrades = all_upgrades.duplicate()
	var x_pos = Vector2(-500, 0)
	var spawn = get_viewport().get_visible_rect().size/2
	for i in 3:
		var random_upgrade_string = temp_upgrades.pick_random()
		var random_upgrade: Strategy_Template = load(upgrades_folder + "/" + random_upgrade_string)
		
		if temp_upgrades.size() > 1:
			temp_upgrades.erase(random_upgrade_string)
		var upgrade_option: Upgrade_UI = load("res://bin/ui/upgrade_ui.tscn").instantiate()
		upgrade_option.position = spawn - upgrade_option.size/2 + x_pos
		upgrade_option.upgrade_name_text = random_upgrade.upgrade_name
		upgrade_option.discription_text = random_upgrade.discription
		upgrade_option.upgrade_path = random_upgrade.resource_path
		
		all_upgrade_uis.append(upgrade_option)
		
		add_child(upgrade_option)
		
		if i == 1:
			upgrade_option.select_button.grab_focus()
		
		x_pos += Vector2(500, 0)
	
	var num = 0
	for item : Upgrade_UI in all_upgrade_uis:
		if num != 0:
			item.select_button.focus_neighbor_left = all_upgrade_uis[num - 1].select_button.get_path()
		if num != all_upgrade_uis.size() - 1:
			item.select_button.focus_neighbor_right = all_upgrade_uis[num + 1].select_button.get_path()
		num += 1
	
	if overflow_of_upgrades == 0:
		upgrade_pause.emit()
	else:
		overflow_of_upgrades -= 1

func _get_upgrade(upgrade: String) -> void:
	for item: Upgrade_UI in all_upgrade_uis:
		remove_child(item)
	
	var chosen_upgrade: Strategy_Template = load(upgrade)
	chosen_upgrade._apply_to_player()
	current_upgrades.append(chosen_upgrade)
	all_upgrade_uis.clear()
	
	if overflow_of_upgrades > 0:
		_level_up()
	else:
		upgrade_pause.emit()
