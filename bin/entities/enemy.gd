class_name Enemy extends Area3D

@onready var material: StandardMaterial3D = $MeshInstance3D.get_active_material(0)
var material_color: Color

var speed = 3
var health = 3

var xp_scene: PackedScene = load("res://bin/entities/xp.tscn")

func _ready() -> void:
	material_color = material.albedo_color

func _physics_process(delta: float) -> void:
	if material_color != material.albedo_color:
		material.albedo_color = material.albedo_color.lerp(material_color, 0.05)
	
	speed = move_toward(speed, 3, 0.1)
	if Player.instance:
		look_at(Vector3(Player.instance.position.x, 1, Player.instance.position.z))
		global_transform.origin -= transform.basis.z.normalized() * speed * delta

func _hit() -> void:
	material.albedo_color = Color(0.5, 0, 0, 1)
	speed = 1.5
	health -= 1
	if health < 1:
		var xp: Xp = xp_scene.instantiate()
		xp.position = position
		add_sibling(xp)
		queue_free()
