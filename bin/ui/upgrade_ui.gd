class_name Upgrade_UI extends ColorRect

@export var upgrade_name_text: String
@export var discription_text: String
@export var upgrade_path: String

@onready var upgrade: Label = $Name
@onready var discription: Label = $Discription
@onready var select_button: Button = $"Select button"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade.text = upgrade_name_text
	discription.text = discription_text

func _on_button_button_up() -> void:
	if select_button.is_hovered():
		Player_values._get_upgrade(upgrade_path)
