class_name Bullet extends Area3D

var damage: float = 10
var piercing: int = 0
var speed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform.origin -= transform.basis.z.normalized() * speed * delta

func _on_area_entered(area: Area3D) -> void:
	if area is Enemy:
		area._hit(damage)
		if piercing < 1:
			queue_free()
		piercing -= 1
			

func _on_timer_timeout() -> void:
	queue_free()
