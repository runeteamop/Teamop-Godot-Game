extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const rotation_speed = 10

@onready var turret = $Turret
@onready var camera = $Camera
@onready var body = $Body

@onready var target_plane = Plane(Vector3(0, 1, 0), position.y)
var ray_lenght = 100

var bullet_scene = preload("res://scenes/bullet.tscn")

func _physics_process(delta: float) -> void:
	var input_dir:= Input.get_vector("Left", "Right", "Up", "Down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 0.5)
		velocity.z = move_toward(velocity.z, 0, 0.5)
	
	if velocity.length() > 0:
		var facing_dir = atan2(-velocity.x, -velocity.z)
		body.rotation.y = lerp_angle(body.rotation.y, facing_dir, 0.05)
	
	move_and_slide()
	
	turret.global_transform.basis = _turn_turret(turret.global_transform, delta)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left Click"):
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.target = _mouse_pos_on_plane()
		bullet.position = position
		add_sibling(bullet)

func _mouse_pos_on_plane():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_lenght
	return(target_plane.intersects_ray(from, to))

func _turn_turret(turret_transform: Transform3D, delta):
	var mouse_pos = _mouse_pos_on_plane()
	var current_trans = turret_transform
	var target_trans = current_trans.looking_at(mouse_pos, Vector3.UP)
	
	return(current_trans.basis.slerp(target_trans.basis, rotation_speed * delta))

func _spawn_bullet() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.target = _mouse_pos_on_plane()
	bullet.position = position
	add_sibling(bullet)
