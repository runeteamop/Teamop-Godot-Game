class_name Enemy extends Area3D

const SPEED = 3

var target

func _physics_process(delta: float) -> void:
	if Player.instance:
		target = Player.instance.position
		look_at(target)
		global_transform.origin -= transform.basis.z.normalized() * SPEED * delta

func _hit() -> void:
	print("hey")
	queue_free()
