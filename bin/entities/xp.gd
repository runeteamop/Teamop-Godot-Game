class_name Xp extends Area3D

var player: CharacterBody3D
var speed: float = 2

func _physics_process(_delta: float) -> void:
	rotate_y(0.05)
	if player:
		var player_pos = player.position
		global_position = global_position.move_toward(player_pos, _delta * speed)
		speed += 0.1
		
		if global_position == player_pos:
			Player_values.xp += 1
			queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
