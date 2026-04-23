extends Node3D

@onready var player: Player = $Player

func _ready() -> void:
	Global.root.ui.add_scene(Global.UID.pause_menu)


func _on_timer_timeout() -> void:
	var angle: float = randf() * TAU

	var spawn_circle := Vector3(sin(angle), 0, cos(angle)) * 17.0

	var enemy: Area3D = preload(LOAD_SCENE.enemy).instantiate()

	enemy.position = spawn_circle + Vector3(player.position.x, 1, player.position.z)

	add_child(enemy)
