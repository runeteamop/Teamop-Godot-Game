class_name Piercing_upgrade extends Upgrade_Template

func _apply_to_bullet():
	Bullet.base_piercing += 1
