class_name Hitbox extends Area3D

@export var damage: int

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: Area3D) -> void:
	if hurtbox is Hurtbox:
		hurtbox.deal_damage(damage)
