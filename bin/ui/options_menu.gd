class_name OptionsMenu extends Control

@export var toggle_fullscreen: CheckBox
@export var resolusion_scale: OptionButton

func _ready() -> void:
	var option_value: Dictionary[String, Variant] = Options.load_options_as_dictionary()
	toggle_fullscreen.button_pressed = option_value.fullscreen
	resolusion_scale.selected = option_value.resolusion_scale

func _on_check_box_toggled(toggled_on: bool) -> void:
	Options.save("display", "fullscreen", toggled_on)

func _on_option_button_item_selected(index: int) -> void:
	Options.save("display", "resolusion_scale", index)

func _on_back_pressed() -> void:
	Global.emit_signal("goto_last_menu")

func _on_apply_pressed() -> void:
	Options.apply()
