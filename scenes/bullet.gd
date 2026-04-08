class_name Bullet extends Area3D

@export var target: Vector3

const SPEED = 20

var velocity: Vector3

func _ready() -> void:
	look_at(target, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform.origin -= transform.basis.z.normalized() * SPEED * delta
