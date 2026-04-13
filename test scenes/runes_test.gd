extends Node3D

@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var angle: float = randf() * TAU
	var spawn_circle := Vector3(sin(angle), 0, cos(angle)) * 8.0
	
	var enemy: Node = load(LOAD_SCENE.enemy).instantiate()
	 
	enemy.position = spawn_circle + player.position
	enemy.player = player
	
	add_sibling(enemy)
