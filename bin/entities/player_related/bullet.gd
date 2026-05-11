class_name Bullet extends Area3D

var damage: float = 10
var piercing: int = 0
var speed = 10
var knockback = 2

var is_homing: bool = false
var homing_area: Area3D

func  _ready() -> void:
	if is_homing:
		homing_area = $"Homing detection"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_homing:
		var temp_enemy: Enemy = null
		for area in homing_area.get_overlapping_areas():
			if area is Enemy:
				if temp_enemy:
					if angle_from_bullet(temp_enemy) < 0.2:
						temp_enemy = area
					elif position.distance_to(area.position) < position.distance_to(temp_enemy.position):
						temp_enemy = area
				else:
					temp_enemy = area
		
		if temp_enemy:
			if angle_from_bullet(temp_enemy) > 0.2:
				var b = atan2(-temp_enemy.position.x - -position.x, -temp_enemy.position.z - -position.z)
				rotation.y = lerp_angle(rotation.y, b, 2 * delta)
	
	global_transform.origin -= transform.basis.z.normalized() * speed * delta

func _on_area_entered(area: Area3D) -> void:
	if area is Enemy:
		area._hit(damage, knockback)
		if piercing < 1:
			queue_free()
		piercing -= 1

func _on_timer_timeout() -> void:
	queue_free()

func angle_from_bullet(area: Area3D):
	return -global_basis.z.dot((area.global_position - global_position).normalized())
