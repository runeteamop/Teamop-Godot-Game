extends Node

signal upgrade_pause
signal xp_changed
signal dash_cooldown_changed

var upgrades: Dictionary ={
	"fire ball": "gives fire dmg over time",
	"machine gun": "makes you fire faster"
}

var amount_of_upgrades: int

var all_upgrade_uis: Array

const starting_levelup_threshold = 1

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
	amount_of_upgrades = upgrades.size()

func _level_up() -> void:
	var x_pos = Vector2(-500, 0)
	var spawn = get_viewport().get_visible_rect().size/2
	for i in 3:
		var random_key = upgrades.keys()[randi() % amount_of_upgrades]
		print(random_key)
		
		print(random_key[0])
		
		var upgrade_option: Upgrade_UI = preload(LOAD_SCENE.upgrade_option).instantiate()
		upgrade_option.position = spawn - upgrade_option.size/2 + x_pos
		upgrade_option.upgrade_name = random_key
		upgrade_option.discription_text = random_key[0]
		
		all_upgrade_uis.append(upgrade_option)
		
		add_child(upgrade_option)
		x_pos += Vector2(500, 0)
	upgrade_pause.emit()

func _get_upgrade() -> void:
	for item: Upgrade_UI in all_upgrade_uis:
		item.queue_free()
	all_upgrade_uis.clear()
	upgrade_pause.emit()
