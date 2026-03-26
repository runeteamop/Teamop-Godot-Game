extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.sa
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom 6gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(_delta) -> void:
	look_at_cursor()

func look_at_cursor():
	var target_plane_mouse = Plane(Vector3(0, 1, 0), position.y)
	var ray_lenght = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = $Camera.project_ray_origin(mouse_pos)
	var to = from + $Camera.project_ray_normal(mouse_pos) * ray_lenght
	var mouse_pos_on_plane = target_plane_mouse.intersects_ray(from, to)
	
	$Turret.look_at(mouse_pos_on_plane, Vector3.UP, 0)
