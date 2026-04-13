extends "res://scenes/bullet.gd"

@export var player: Player

func _physics_process(delta: float) -> void:
	SPEED = 1
	look_at(player.position)

func _on_area_entered(area: Area3D) -> void:
	queue_free()
