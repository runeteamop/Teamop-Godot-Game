class_name Bullet extends Area3D

@onready var hitbox: Hitbox = $Hitbox

var on_hit_upgrades: Array

var damage: float = 10
var piercing: int = 0
var speed: float = 10
var knockback = 2
var homing: float = 0

var velocity: Vector3

var is_homing: bool = false
var homing_area: Area3D

func  _ready() -> void:
	velocity = -global_transform.basis.z
	hitbox.damage = 10
	if is_homing:
		homing_area = $"Homing detection"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_homing:
		var temp_enemy: Enemy = null
		for body in homing_area.get_overlapping_bodies():
			if body is Enemy:
				if temp_enemy:
					if position.distance_to(body.position) < position.distance_to(temp_enemy.position):
						temp_enemy = body
				else:
					temp_enemy = body
		if temp_enemy:
			var direction = position.direction_to(temp_enemy.position)
			direction.y = 0
			velocity = velocity.move_toward(direction, homing)
	
	position += (velocity * speed * delta)
	
	#global_translate(-global_transform.basis.z * speed * delta)

func _on_timer_timeout() -> void:
	queue_free()

func angle_from_bullet_to_body(area: CharacterBody3D):
	return -global_transform.basis.z.dot((area.global_position - global_position).normalized())

func _on_hitbox_extra_hit_logic(enemy) -> void:
	if enemy is Enemy:
		if Player_values.upgrades_with_on_hit_effect:
			for upgrades in Player_values.upgrades_with_on_hit_effect:
				upgrades._bullet_hit_effect(enemy, self)
		
		enemy.speed = enemy.speed - knockback
		
		if piercing < 1:
			queue_free()
		piercing -= 1
