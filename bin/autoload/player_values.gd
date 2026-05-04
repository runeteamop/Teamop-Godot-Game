extends Node

signal upgrade_pause
signal xp_changed
signal dash_cooldown_changed

const STARTING_LEVELUP_THRESHOLD: int = 10
const XP_INCREASE_ON_LEVELUP: int = 5

var upgrades_folder: String = "res://bin/upgrade_resources/"
var all_upgrades: Array
var all_upgrade_uis: Array
var current_upgrades: Array

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
	var temp_upgrades = all_upgrades.duplicate()
	var x_pos = Vector2(-500, 0)
	var spawn = get_viewport().get_visible_rect().size/2
	for i in 3:
		var random_upgrade_string = temp_upgrades.pick_random()
		var random_upgrade: Upgrade_Template = load(upgrades_folder + "/" + random_upgrade_string)
		
		if temp_upgrades.size() > 1:
			temp_upgrades.erase(random_upgrade_string)
		var upgrade_option: Upgrade_UI = load("res://bin/ui/upgrade_ui.tscn").instantiate()
		upgrade_option.position = spawn - upgrade_option.size/2 + x_pos
		upgrade_option.upgrade_name_text = random_upgrade.upgrade_name
		upgrade_option.discription_text = random_upgrade.discription
		upgrade_option.upgrade_path = random_upgrade.resource_path
		
		all_upgrade_uis.append(upgrade_option)
		
		add_child(upgrade_option)
		x_pos += Vector2(500, 0)
	upgrade_pause.emit()

func _get_upgrade(upgrade: String) -> void:
	for item: Upgrade_UI in all_upgrade_uis:
		remove_child(item)
	
	var chosen_upgrade: Upgrade_Template = load(upgrade)
	chosen_upgrade._apply_to_player()
	current_upgrades.append(chosen_upgrade)
	print(current_upgrades)
	all_upgrade_uis.clear()
	upgrade_pause.emit()
