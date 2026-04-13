extends "res://scenes/bullet.gd"

@export var target: Player

func _physics_process(delta: float) -> void:
	SPEED = 1
	look_at(target.position)
	position.y = 1

func _on_area_entered(area: Area3D) -> void:
	queue_free()
