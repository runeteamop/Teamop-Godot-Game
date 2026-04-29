class_name Enemy extends Area3D

var speed = 3
var health = 3

var xp_scene: PackedScene = load("res://bin/entities/xp.tscn")

func _physics_process(delta: float) -> void:
	speed = move_toward(speed, 3, 0.1)
	if Player.instance:
		look_at(Vector3(Player.instance.position.x, 1, Player.instance.position.z))
		global_transform.origin -= transform.basis.z.normalized() * speed * delta

func _hit() -> void:
	speed = 1.5
	health -= 1
	if health < 1:
		var xp: Xp = xp_scene.instantiate()
		xp.position = position
		add_sibling(xp)
		queue_free()

func _on_area_entered(_area: Area3D) -> void:
	queue_free()
