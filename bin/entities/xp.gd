class_name Xp extends Area3D

func _physics_process(delta: float) -> void:
	rotate_y(0.05)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body._xp_collected()
