class_name Bullet_damage extends Upgrade_Template

func _apply_to_bullet(bullet : Bullet):
	bullet.damage += 2
