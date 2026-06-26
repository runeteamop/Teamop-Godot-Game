class_name Enemy extends CharacterBody3D

@onready var material: StandardMaterial3D = $MeshInstance3D.get_active_material(0)
var material_color: Color

var base_speed = 1.5
var speed = 1.5
var health = 40

var xp_scene: PackedScene = load("res://bin/entities/xp.tscn")

func _ready() -> void:
	material_color = material.albedo_color

func _physics_process(_delta: float) -> void:
	if material_color != material.albedo_color:
		material.albedo_color = material.albedo_color.lerp(material_color, 0.05)

	if Player.instance:
		var player_postion: Vector3 = Player.instance.global_position
		player_postion.y = global_position.y
		var direction: Vector3 = (player_postion - global_position).normalized()
		velocity = direction * speed
		speed = move_toward(speed, base_speed, 0.1)
		move_and_slide()

func _hit(damage, knockback) -> void:
	material.albedo_color = Color(1.0, 0.0, 0.0, 1.0)
	speed = speed - knockback
	health -= damage
	if health < 1:
		var xp: Xp = xp_scene.instantiate()
		xp.position = position
		add_sibling(xp)
		queue_free()
