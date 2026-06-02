class_name Strategy_Template extends Resource

@export var upgrade_name: String = "temp"
@export var discription: String = "temp"

@export var _has_bullet_hit_effect: bool = false

func _apply_to_player():
	pass

@warning_ignore("unused_parameter")
func _apply_to_bullet(bullet : Bullet):
	pass

func _bullet_hit_effect(body : Enemy):
	pass
