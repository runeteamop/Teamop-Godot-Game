class_name Bullet extends Area3D

const SPEED = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform.origin -= transform.basis.z.normalized() * SPEED * delta

func _on_timer_timeout() -> void:
	print("brah")
	queue_free()
