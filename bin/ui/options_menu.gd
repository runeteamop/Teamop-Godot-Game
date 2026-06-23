class_name OptionsMenu extends Control

const WINDOW_MODE_VALUES: Array[int] = [0, 3, 4]

@export var window_mode_selector: OptionButton
@export var resolution_scale_slider: HSlider
@export var ui_scale_slider: HSlider
@export var vsync_selector: OptionButton
@export var antialiasing_selector: OptionButton
@export var framerate_limit_slider: HSlider

@export var resolution_scale_percentage: Label
@export var ui_scale_percentage: Label
@export var framerate_limit_number: Label

@onready var indicators: Array[Node] = get_tree().get_nodes_in_group("OptionChangedIndicators")

var options: ConfigFile = OptionsManager.options_file

func _enter_tree() -> void:
	window_mode_selector.selected = WINDOW_MODE_VALUES.find(options.get_value("display", "window_mode"))
	resolution_scale_slider.value = options.get_value("display", "resolution_scale")
	ui_scale_slider.value = options.get_value("display", "ui_scale")
	vsync_selector.selected = options.get_value("display", "vertical_syncronization")
	antialiasing_selector.selected = options.get_value("display", "antialiasing")

	resolution_scale_percentage.text = "%s%%" % int(options.get_value("display", "resolution_scale") * 100)
	ui_scale_percentage.text = "%s%%" % int(options.get_value("display", "ui_scale") * 100)

	if options.get_value("display", "framerate_limit") == 0:
		framerate_limit_slider.value = 501
		framerate_limit_number.text = "Unlimited"
	else:
		framerate_limit_slider.value = options.get_value("display", "framerate_limit")
		framerate_limit_number.text = "%s" % str(options.get_value("display", "framerate_limit"))

func _option_changed_checker(option_changed_indicator: Label, section: String, key: String, value: Variant) -> void:
	option_changed_indicator.visible = true if options.get_value(section, key) != value else false

func _on_back_pressed() -> void:
	for indicator in indicators:
		indicator.visible = false
	Global.goto_last_menu()

func _on_apply_pressed() -> void:
	OptionsManager.save_options()
	OptionsManager.apply_all_options()

	for indicator in indicators:
		indicator.visible = false

func _on_window_mode_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "window_mode", WINDOW_MODE_VALUES[index])
	_option_changed_checker(indicators[0], "display", "window_mode", index)

func _on_resolution_scale_slider_value_changed(value: float) -> void:
	OptionsManager.options_to_buffer("display", "resolution_scale", value)
	_option_changed_checker(indicators[1], "display", "resolution_scale", value)
	resolution_scale_percentage.text = "%s%%" % int(value * 100)

func _on_ui_scale_slider_value_changed(value: float) -> void:
	OptionsManager.options_to_buffer("display", "ui_scale", value)
	_option_changed_checker(indicators[2], "display", "ui_scale", value)
	ui_scale_percentage.text = "%s%%" % int(value * 100)

func _on_v_sync_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "vertical_syncronization", index)
	_option_changed_checker(indicators[3], "display", "vertical_syncronization", index)

func _on_anti_aliasing_selector_item_selected(index: int) -> void:
	OptionsManager.options_to_buffer("display", "antialiasing", index)
	_option_changed_checker(indicators[4], "display", "antialiasing", index)

func _on_framerate_limit_slider_value_changed(value: int) -> void:
	OptionsManager.options_to_buffer("display", "framerate_limit", value if value != 501 else 0)
	_option_changed_checker(indicators[5], "display", "ui_scale", value)
	framerate_limit_number.text = "%s" % value if value != 501 else "Unlimited"
