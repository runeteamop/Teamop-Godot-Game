extends ColorRect

@onready var upgrade_name: Label = $Name
@onready var discription: Label = $Discription

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_name.text = "fire ball"
	discription.text = "gives you projectile fire dmg"
