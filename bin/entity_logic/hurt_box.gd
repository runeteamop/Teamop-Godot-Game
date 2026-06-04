class_name Hurtbox extends Area3D

@export var parent: Node3D
@export var i_frames: float = 0.5

signal hurt(damage: int)

func deal_damage(damage) -> void:
	get_tree().create_timer(i_frames).timeout.connect(i_frames_end)
	set_deferred("monitorable", false)
	hurt.emit(damage)

func i_frames_end() -> void:
	set_deferred("monitorable", true)
