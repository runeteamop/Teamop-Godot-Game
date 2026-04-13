extends Node3D

@onready var player: Player = $Player

func _on_timer_timeout() -> void:
	var angle: float = randf() * TAU
	var spawn_circle := Vector3(sin(angle), 0, cos(angle)) * 8.0
	
	var enemy: Area3D = load(LOAD_SCENE.enemy).instantiate()
	 
	enemy.position = spawn_circle + player.position
	enemy.player = player
	
	add_sibling(enemy)
