class_name Explosion extends Node3D

@export var explosion_damage : int = 0

@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var detection : ShapeCast3D = $ShapeCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(mesh, "transparency", 1, 1)
	tween.tween_callback(queue_free)
	
	detection.force_shapecast_update()
	for i in detection.get_collision_count():
		var collider = detection.get_collider(i)
		if collider is Hurtbox:
			collider.hurt.emit(explosion_damage)
