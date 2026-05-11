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
					var area_angle = -global_basis.z.dot(area.global_position - global_position)
					if area_angle > -global_basis.z.dot(temp_enemy.global_position - global_position):
						temp_enemy = area
				else:
					temp_enemy = area
		
		if temp_enemy:
			var b = atan2(-temp_enemy.position.x - -position.x, -temp_enemy.position.z - -position.z)
			rotation.y = lerp_angle(rotation.y, b, 5 * delta)
	
	global_transform.origin -= transform.basis.z.normalized() * speed * delta

func _on_area_entered(area: Area3D) -> void:
	if area is Enemy:
		area._hit(damage, knockback)
		if piercing < 1:
			queue_free()
		piercing -= 1

func _on_timer_timeout() -> void:
	queue_free()
