class_name Bullet extends Area3D

var damage: float = 10
var piercing: int = 0
var speed = 10
var knockback = 2
var homing: float = 0

var is_homing: bool = false
var homing_area: Area3D

func  _ready() -> void:
	if is_homing:
		homing_area = $"Homing detection"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_homing:
		var temp_enemy: Enemy = null
		for area in homing_area.get_overlapping_areas():
			if area is Enemy:
				if temp_enemy:
					if angle_from_bullet_to_area(temp_enemy) < 0.2:
						temp_enemy = area
					elif area.position.distance_to(global_position) < temp_enemy.position.distance_to(global_position):
						temp_enemy = area
				else:
					temp_enemy = area
		
		if temp_enemy:
			var angle = angle_from_bullet_to_area(temp_enemy)
			if angle > 0.2:
				if angle < 0.999:
					var rotation_to_enemy: Vector3 = -global_transform.basis.z.cross((temp_enemy.global_position - global_position).normalized()).normalized()
					if rotation_to_enemy.is_normalized():
						global_transform.basis = global_transform.basis.rotated(rotation_to_enemy, homing * delta)
						global_transform.basis = global_transform.basis.orthonormalized()
	
	global_translate(-global_transform.basis.z * speed * delta)

func _on_area_entered(area: Area3D) -> void:
	if area is Enemy:
		area._hit(damage, knockback)
		if piercing < 1:
			queue_free()
		piercing -= 1

func _on_timer_timeout() -> void:
	queue_free()

func angle_from_bullet_to_area(area: Area3D):
	return -global_transform.basis.z.dot((area.global_position - global_position).normalized())
