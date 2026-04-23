extends CanvasLayer

@onready var dash_progressbar: ProgressBar = $"Dash cooldown bar"
@onready var xp_bar: ProgressBar = $"Xp bar"

func _ready() -> void:
	xp_bar.max_value = Player_values.starting_levelup_threshold
	dash_progressbar.hide()
	Player_values.xp_changed.connect(_xp_bar)
	Player_values.dash_cooldown_changed.connect(_dash_cooldown)

func _xp_bar(xp_value: float) -> void:
	if xp_value >= xp_bar.max_value:
		Player_values.xp = 0
		xp_bar.max_value += 5
		Player_values._level_up()
	xp_bar.value = Player_values.xp

func _dash_cooldown(dash_cooldown) -> void:
	if dash_cooldown == 0:
		dash_progressbar.hide()
	else:
		dash_progressbar.visible = true
		dash_progressbar.value = dash_cooldown
