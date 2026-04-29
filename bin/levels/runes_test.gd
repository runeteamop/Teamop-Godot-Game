extends Node3D

@onready var player: Player = $Player

func _ready() -> void:
	Player_values.upgrade_pause.connect(pause)

func _on_timer_timeout() -> void:
	var angle: float = randf() * TAU

	var spawn_circle := Vector3(sin(angle), 0, cos(angle)) * 17.0

	var enemy: Area3D = load("res://bin/entities/enemy.tscn").instantiate()

	enemy.position = spawn_circle + Vector3(player.position.x, 1, player.position.z)
	
	add_child(enemy)

func pause() -> void:
	if process_mode == PROCESS_MODE_DISABLED:
		set_deferred("process_mode", PROCESS_MODE_ALWAYS)
	else:
		set_deferred("process_mode", PROCESS_MODE_DISABLED)
