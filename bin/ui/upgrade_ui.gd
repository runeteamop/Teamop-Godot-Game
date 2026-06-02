class_name Upgrade_UI extends ColorRect

@export var upgrade_name_text: String
@export var discription_text: String
@export var upgrade_path: String
@export var selected_value: int = 0
@export var upgrade_options: int = 0

@onready var upgrade: Label = $Name
@onready var discription: Label = $Discription
@onready var select_button: Button = $"Select button"

var base_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_color = color
	upgrade.text = upgrade_name_text
	discription.text = discription_text

func _on_select_button_pressed() -> void:
	Player_values._get_upgrade(upgrade_path)

func make_base_color() -> void:
	color = base_color

func make_selection_color() -> void:
	select_button.grab_focus()
	color = Color(0, 0.5, 0.5, 0.4)
