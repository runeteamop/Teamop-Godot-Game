extends Bullet

@export var target: Player

func _physics_process(_delta: float) -> void:
	SPEED = 1
	look_at(target.position)
	position.y = 1

func _on_area_entered(_area: Area3D) -> void:
	queue_free()
