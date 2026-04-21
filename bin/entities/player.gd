class_name Player extends CharacterBody3D

static var instance: Player

const rotation_speed = 10

var reload_time: float = 1
var r_stick_dir: float
var current_control_type: String
var speed: float = 5.0
var can_dash: bool = true

@onready var dash_cooldown: Timer = $"Dash Cooldown"
@onready var turret: Marker3D = $Turret
@onready var camera := $Camera
@onready var body: MeshInstance3D = $Body
@onready var dash_progressbar: ProgressBar = $ProgressBar
@onready var turret_cannon: Node3D = $"Turret/Cannon/Cannon End"

@onready var target_plane = Plane(Vector3(0, 1, 0), position.y)

var bullet_scene: PackedScene = load(LOAD_SCENE.bullet)

func _init() -> void:
	if !instance: 
		instance = self

func _notifications(notification) -> void:
	if notification == NOTIFICATION_PREDELETE:
		if instance == self: instance = null

func _physics_process(delta: float) -> void:
	var input_dir:= Input.get_vector("Left", "Right", "Up", "Down")
	
	dash_progressbar.value = dash_cooldown.wait_time - dash_cooldown.time_left
	
	if Input.is_action_pressed("Left Click"):
		current_control_type = "Mouse"
		_shoot()
	speed = move_toward(speed, 5, 1)
	
	if input_dir:
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, 0.3)
		velocity.z = move_toward(velocity.z, 0, 0.3)
	
	if velocity.length() > 0:
		var facing_dir = atan2(-velocity.x, -velocity.z)
		body.rotation.y = lerp_angle(body.rotation.y, facing_dir, 0.05)
	
	reload_time += delta
	
	if current_control_type == "Mouse":
		_mouse_turn_turret(delta)
	elif current_control_type == "Controller":
		turret.rotation.y = lerp_angle(turret.rotation.y, r_stick_dir, rotation_speed * delta)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Dash") && can_dash == true:
		can_dash = false
		dash_progressbar.visible = true
		dash_progressbar.value = 0
		dash_cooldown.start(1.5)
		speed = speed * 6
	if event is InputEventJoypadMotion:
		var sticK_sin = abs(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
		var stick_cos = abs(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
		if sticK_sin > 0.4 or stick_cos > 0.4:
			current_control_type = "Controller"
			r_stick_dir = -Vector2(-Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)).angle()
			_shoot()

func _shoot() -> void:
	if reload_time > 0.5:
		reload_time = 0.0
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.rotation = turret.rotation
		bullet.position = turret_cannon.global_position
		
		add_sibling(bullet)

func _mouse_pos_on_plane():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = camera.project_ray_normal(mouse_pos)
	
	return(target_plane.intersects_ray(from, to))

func _mouse_turn_turret(delta):
	var mouse_pos = _mouse_pos_on_plane()
	if mouse_pos == null:
		return(turret.global_transform.basis)
	var target_trans = turret.global_transform.looking_at(mouse_pos, Vector3.UP)
	
	turret.global_transform.basis = turret.global_transform.basis.slerp(target_trans.basis, rotation_speed * delta)


func _on_dash_cooldown_timeout() -> void:
	dash_progressbar.hide()
	can_dash = true
