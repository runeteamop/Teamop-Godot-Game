class_name Enemy_manager extends Node

@export var player: Player

func _on_timer_timeout() -> void:
	if player:
		var angle: float = randf() * TAU

		var spawn_circle := Vector3(sin(angle), 0, cos(angle)) * 17.0

		var enemy: CharacterBody3D = load("res://bin/entities/enemy.tscn").instantiate()

		enemy.position = spawn_circle + Vector3(player.position.x, 1, player.position.z)
		
		add_child(enemy)
