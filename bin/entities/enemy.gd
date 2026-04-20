class_name Enemy extends Bullet

@export var target: Player

func _physics_process(delta: float) -> void:
	SPEED = 2
	look_at(target.position)
	position.y = 1

func _hit() -> void:
	queue_free()
