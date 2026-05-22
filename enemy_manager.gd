class_name Enemy_manager extends Node

@export var player: Player
@export var environment: Node3D

func _on_timer_timeout() -> void:
	if environment:
		var angle: float = randf() * TAU

		var spawn_circle := Vector3(sin(angle), 0, cos(angle)) * 17.0

		var enemy: CharacterBody3D = preload("res://bin/entities/enemy.tscn").instantiate()

		enemy.position = spawn_circle + Vector3(player.position.x, 1, player.position.z)

		environment.add_child(enemy)
