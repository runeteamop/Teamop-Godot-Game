class_name Player extends CharacterBody3D

const SPEED = 5.0
const rotation_speed = 10

var reload_time: float = 1
var r_stick_dir
var current_control_type

@onready var turret: Marker3D = $Turret
@onready var camera = $Camera
@onready var body = $Body
@onready var turret_cannon: Node3D = $"Turret/Cannon/Cannon End"

@onready var target_plane = Plane(Vector3(0, 1, 0), position.y)
var ray_lenght = 100

var bullet_scene: PackedScene = load(LOAD_SCENE.bullet)

func _physics_process(delta: float) -> void:
	var input_dir:= Input.get_vector("Left", "Right", "Up", "Down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("Left Click"):
		current_control_type = "Mouse"
		_shoot()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 0.5)
		velocity.z = move_toward(velocity.z, 0, 0.5)
	
	if velocity.length() > 0:
		var facing_dir = atan2(-velocity.x, -velocity.z)
		body.rotation.y = lerp_angle(body.rotation.y, facing_dir, 0.05)
	
	reload_time += delta
	
	if current_control_type == "Mouse":
		turret.global_transform.basis = _mouse_turn_turret(turret.global_transform, delta)
	elif current_control_type == "Controller":
		turret.rotation.y = lerp_angle(turret.rotation.y, r_stick_dir, rotation_speed * delta)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	var sin = abs(Input.get_joy_axis(0, 3))
	var cos = abs(Input.get_joy_axis(0, 2))
	if event is InputEventJoypadMotion and (sin > 0.1 or cos > 0.1):
		current_control_type = "Controller"
		r_stick_dir = -Vector2(-(Input.get_joy_axis(0, 3)), Input.get_joy_axis(0, 2)).angle()
		_shoot()

func _shoot() -> void:
	if reload_time > 0.5:
		reload_time = 0
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.rotation = turret.rotation
		bullet.position = turret_cannon.global_position
		
		add_sibling(bullet)

func _mouse_pos_on_plane():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_lenght
	return(target_plane.intersects_ray(from, to))

func _mouse_turn_turret(turret_transform: Transform3D, delta):
	var mouse_pos = _mouse_pos_on_plane()
	var current_trans = turret_transform
	var target_trans = current_trans.looking_at(mouse_pos, Vector3.UP)
	
	return(current_trans.basis.slerp(target_trans.basis, rotation_speed * delta))
