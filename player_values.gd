extends Node

signal xp_changed
signal dash_cooldown_changed

var xp: float = 0:
	set(value):
		if xp != value:
			xp = value
			xp_changed.emit(xp)

var dash_cooldown: float = 0:
	set(value):
		if dash_cooldown != value:
			dash_cooldown = value
			dash_cooldown_changed.emit(value)
