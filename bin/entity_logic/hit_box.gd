class_name Hitbox extends Area3D

signal extra_hit_logic

@export var has_extra_hit_logic: bool = false
@export var damage: int
@export var knockback: int

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: Area3D) -> void:
	if hurtbox is Hurtbox:
		hurtbox.deal_damage(damage)
		if has_extra_hit_logic == true:
			extra_hit_logic.emit(hurtbox.parent)
