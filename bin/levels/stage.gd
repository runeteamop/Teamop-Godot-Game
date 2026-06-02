extends Node

@onready var player: Player = $"3D environment/Player"
@onready var enemy_manager: Enemy_manager = $"enemy manager"

func _ready() -> void:
	enemy_manager.environment = $"3D environment"
	enemy_manager.player = player
	Player_values.upgrade_pause.connect(pause)

func pause() -> void:
	if process_mode == PROCESS_MODE_DISABLED:
		set_deferred("process_mode", PROCESS_MODE_PAUSABLE)
	else:
		set_deferred("process_mode", PROCESS_MODE_DISABLED)
