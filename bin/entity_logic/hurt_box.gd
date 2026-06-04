class_name Hurtbox extends Area3D

@export var has_i_frames: bool = false
@export var i_frames: float = 0
@export var parent: Node3D

signal hurt(damage: int)

func deal_damage(damage) -> void:
	get_tree().create_timer(i_frames).timeout.connect(i_frames_end)
	if has_i_frames == true:
		set_deferred("monitorable", false)
	hurt.emit(damage)

func i_frames_end() -> void:
	set_deferred("monitorable", true)
