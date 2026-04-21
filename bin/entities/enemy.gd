class_name Enemy extends Area3D

const SPEED = 3

func _physics_process(delta: float) -> void:
	if Player.instance:
		look_at(Player.instance.position)
		global_transform.origin -= transform.basis.z.normalized() * SPEED * delta

func _hit() -> void:
	queue_free()
