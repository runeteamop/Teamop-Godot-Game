class_name Bullet extends Area3D

var SPEED = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform.origin -= transform.basis.z.normalized() * SPEED * delta

func _on_timer_timeout() -> void:
	queue_free()
