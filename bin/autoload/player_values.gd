extends Node

signal upgrade_pause
signal xp_changed
signal dash_cooldown_changed
signal health_changed
signal max_health_changed
signal apply_upgrade

const STARTING_LEVELUP_THRESHOLD: int = 1
const XP_INCREASE_ON_LEVELUP: int = 0

var upgrades_folder: String = "res://bin/upgrade_resources/"
var all_upgrades: Array
var all_upgrade_uis: Array[Upgrade_UI]
var current_upgrades: Array[Strategy_Template]
var upgrades_with_on_hit_effect: Array[Strategy_Template]
var overflow_of_upgrades: int = 0

var reload_speed = 0.5

var health: int = 20:
	set(value):
		if health != value:
			health = value
			health_changed.emit()

var max_health: int = 20:
	set(value):
		if max_health != value:
			max_health = value
			max_health_changed.emit()

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

func _get_upgrade(upgrade: String) -> void:
	var chosen_upgrade: Strategy_Template = load(upgrade)
	
	apply_upgrade.emit(chosen_upgrade)
	
	if chosen_upgrade.one_time_upgrade == true:
		pass
	
	if chosen_upgrade._has_bullet_hit_effect == true:
		upgrades_with_on_hit_effect.append(chosen_upgrade)
	chosen_upgrade._apply_to_player()
	current_upgrades.append(chosen_upgrade)

func _pause():
	upgrade_pause.emit()
