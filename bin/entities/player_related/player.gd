class_name Player extends CharacterBody3D

static var instance: Player

const rotation_speed = 10

var reload_time: float = 1
var r_stick_dir: float
var current_control_type: String
var speed: float = 5.0
var can_dash: bool = true

# Variables for controlling leg movement
var is_dashing: bool = false

@onready var dash_cooldown: Timer = $"Dash cooldown timer"
@onready var turret: Marker3D = $Turret
@onready var camera := $Camera
@onready var body: MeshInstance3D = $Body
@onready var turret_cannon: Node3D = $"Turret/Cannon/Cannon End"
@onready var hurtbox: Hurtbox = $Hurtbox

@onready var target_plane : Plane

# On-ready variables for controlling leg movement
@onready var step_items_wrapper = $SpiderLegs/LegMarkerWrapper

@onready var legs: Dictionary = {
	is_moving_index = 0,
	# 0 -> No leg moving
	# 1 -> SW leg moving
	# 2 -> NW leg moving
	# 3 -> SE leg moving
	# 4 -> NE leg moving
	
	SW = {
		marker_current_target = $SpiderLegs/LegMarkerWrapper/LegSWTarget,
		marker_new_target = $SpiderLegs/LegMarkerWrapper/LegSWNewTarget,
		#is_moving = false
	},
	
	NW = {
		marker_current_target = $SpiderLegs/LegMarkerWrapper/LegNWTarget,
		marker_new_target = $SpiderLegs/LegMarkerWrapper/LegNWNewTarget,
		#is_moving = false
	},
	
	SE = {
		marker_current_target = $SpiderLegs/LegMarkerWrapper/LegSETarget,
		marker_new_target = $SpiderLegs/LegMarkerWrapper/LegSENewTarget,
		#is_moving = false
	},
	
	NE = {
		marker_current_target = $SpiderLegs/LegMarkerWrapper/LegNETarget,
		marker_new_target = $SpiderLegs/LegMarkerWrapper/LegNENewTarget,
		#is_moving = false
	}
}

var bullet_scene: PackedScene = load("res://bin/entities/player_related/bullet.tscn")

var look_here: float

func _init() -> void:
	if !instance:
		instance = self

func _ready() -> void:
	hurtbox.hurt.connect(_received_damage)
	target_plane = Plane(Vector3(0, 1, 0), (turret.global_position.y))

func _notifications(notif) -> void:
	if notif == NOTIFICATION_PREDELETE:
		if instance == self: instance = null

func _physics_process(delta: float) -> void:
	var input_dir:= Input.get_vector("Left", "Right", "Up", "Down")

	if can_dash == false:
		if speed > 5.5:
			var material_for_after_image : BaseMaterial3D = body.get_active_material(0).duplicate()
			material_for_after_image.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			material_for_after_image.albedo_color = Color(0.5, 0.6, 1.0, 0.15)

			var after_image = body.duplicate()
			after_image.position = position
			after_image.material_override = material_for_after_image
			after_image.get_child(0).material_override = material_for_after_image

			var tween = create_tween()
			tween.tween_property(after_image, "transparency", 1, 0.2)
			tween.tween_callback(after_image.queue_free)

			add_sibling(after_image)
		else:
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)
			is_dashing = false

		Player_values.dash_cooldown = dash_cooldown.wait_time - dash_cooldown.time_left

	if Input.is_action_pressed("Left Click"):
		_shoot()

	if Input.is_action_pressed("Left Click"):
		current_control_type = "Mouse"
		_shoot()

	if input_dir:
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, 0.3)
		velocity.z = move_toward(velocity.z, 0, 0.3)

	if velocity.length() > 0:
		var facing_dir = atan2(-velocity.x, -velocity.z)
		body.rotation.y = lerp_angle(body.rotation.y, facing_dir, 0.05)

	speed = move_toward(speed, 5, 1)
	reload_time += delta

	if current_control_type == "Mouse":
		var mouse_pos_viewport = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos_viewport)
		var to = camera.project_ray_normal(mouse_pos_viewport)
		var mouse_pos = target_plane.intersects_ray(from, to)
		look_here = atan2(-mouse_pos.x - -position.x, -mouse_pos.z - -position.z)
	elif current_control_type == "Controller":
		look_here = r_stick_dir

	turret.rotation.y = lerp_angle(turret.rotation.y, look_here, rotation_speed * delta)
	
	# Normal behavior for the legs when the spider is not dashing
	if !is_dashing:
		if velocity.length() > 0:
			step_items_wrapper.position = lerp(step_items_wrapper.position, velocity * .5, .2)
		else:
			step_items_wrapper.position = Vector3(0,0,0)
		
		#TODO:
		"""
		function to choose leg to move
		function for moving the leg
		should i make an object(/class?) to keep all the leg data inside it? - yes
		data for each leg:
			moving: bool
			3 variables to markers for target, pole, and newtarget
			(varible to connect to leg root node probably not needed)
		object should be in a seperate script to keep this script clean
		(or as clean as can be lol)
		"""
	"""
	if !dashing:
		move leg furthest from intended position
		can move leg if adjacent legs are not moving
		timer to wait to move leg again
	"""

	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Dash") && can_dash == true:
		is_dashing = true
		set_collision_layer_value(1 , false)
		set_collision_mask_value(1 , false)
		can_dash = false
		dash_cooldown.start(1.5)
		speed = speed * 6

	if event is InputEventMouse:
		current_control_type = "Mouse"

	if event is InputEventJoypadMotion:
		var sticK_sin = abs(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
		var stick_cos = abs(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
		if sticK_sin > 0.4 or stick_cos > 0.4:
			current_control_type = "Controller"
			r_stick_dir = -Vector2(-Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)).angle()
			_shoot()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	Player_values.dash_cooldown = 0

func _shoot() -> void:
	if reload_time > Player_values.reload_speed:
		reload_time = 0.0
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.rotation = turret.rotation
		bullet.position = turret_cannon.global_position

		for upgrade : Strategy_Template in Player_values.current_upgrades:
			upgrade._apply_to_bullet(bullet)

		add_sibling(bullet)

func _received_damage(damage : int) -> void:
	Player_values.health -= damage

# Functions for controlling leg movement
func choose_leg(legs: Dictionary) -> int:
	return 0

func find_lowest_distances(legs: Dictionary) -> Array:
	return []

# Okay, there needs to be an array that contains all the legs to loop through
# Maybe it's better to switch to gitea before I do this? IDK
# There's a lot of unknowns in this project right now...
