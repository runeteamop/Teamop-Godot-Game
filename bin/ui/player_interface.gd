extends Control

@onready var dash_progressbar: ProgressBar = $"Dash cooldown bar"
@onready var xp_bar: ProgressBar = $"Xp bar"
@onready var health_bar: ProgressBar = $"Health bar"
@onready var health_display: Label = $"Health bar/Health display"

func _ready() -> void:
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
		Player_values._level_up()
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
