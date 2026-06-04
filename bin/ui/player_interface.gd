extends Control

@onready var dash_progressbar: ProgressBar = $"Dash cooldown bar"
@onready var xp_bar: ProgressBar = $"Xp bar"
@onready var health_bar: ProgressBar = $"Health bar"
@onready var health_display: Label = $"Health bar/Health display"

var upgrades_folder: String = "res://bin/upgrade_resources/"
var all_upgrades: Array
var all_upgrade_uis: Array[Upgrade_UI]
var current_upgrades: Array
var overflow_of_upgrades: int = 0

func _ready() -> void:
	Player_values.apply_upgrade.connect(_applying_upgrade)
	all_upgrades = DirAccess.get_files_at(upgrades_folder)
	xp_bar.max_value = Player_values.STARTING_LEVELUP_THRESHOLD
	dash_progressbar.hide()
	health_display.text = str(Player_values.health, " / ", Player_values.max_health)
	health_bar.max_value = Player_values.max_health
	health_bar.value = Player_values.health
	health_bar.custom_minimum_size.x = 300 + Player_values.max_health * 2
	
	Player_values.xp_changed.connect(_xp_bar)
	Player_values.dash_cooldown_changed.connect(_dash_cooldown)
	Player_values.health_changed.connect(_health)
	Player_values.max_health_changed.connect(_health)

func _xp_bar(xp_value: float) -> void:
	if xp_value >= xp_bar.max_value:
		Player_values.xp = 0
		xp_bar.max_value += Player_values.XP_INCREASE_ON_LEVELUP
		_level_up()
	xp_bar.value = Player_values.xp

func _dash_cooldown(dash_cooldown) -> void:
	if dash_cooldown == 0:
		dash_progressbar.hide()
	else:
		dash_progressbar.visible = true
		dash_progressbar.value = dash_cooldown

func _health() -> void:
	health_display.text = str(Player_values.health, " / ", Player_values.max_health)
	health_bar.max_value = Player_values.max_health
	health_bar.value = Player_values.health
	health_bar.size.x = 300 + Player_values.max_health * 2

func _level_up():
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
		Player_values._pause()
	else:
		overflow_of_upgrades -= 1

func _applying_upgrade(chosen_upgrade : Strategy_Template):
	
	if chosen_upgrade.one_time_upgrade == true:
		all_upgrades.erase(chosen_upgrade.resource_path.get_file())
	
	for item: Upgrade_UI in all_upgrade_uis:
		remove_child(item)
	
	all_upgrade_uis.clear()
	
	if overflow_of_upgrades > 0:
		Player_values._level_up()
	else:
		Player_values.upgrade_pause.emit()
