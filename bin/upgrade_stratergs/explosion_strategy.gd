class_name Explosion_upgrade extends Strategy_Template

var damage : int

func _bullet_hit_effect(body : Enemy, bullet : Bullet):
	var explosion_path = load("res://bin/effects/explosion effect.tscn")
	var explosion : Explosion = explosion_path.instantiate()
	explosion.position = body.position
	explosion.explosion_damage = bullet.damage
	body.add_sibling(explosion)
