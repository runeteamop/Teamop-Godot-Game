class_name Bullet_rate_upgrade extends Upgrade_Template

func _apply_to_player():
	Player_values.reload_speed = Player_values.reload_speed - Player_values.reload_speed/10
