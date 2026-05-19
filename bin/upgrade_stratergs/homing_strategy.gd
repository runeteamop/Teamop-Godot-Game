class_name Homing_upgrade extends Strategy_Template

func _apply_to_bullet(bullet : Bullet):
	bullet.is_homing = true
	bullet.homing += 1
