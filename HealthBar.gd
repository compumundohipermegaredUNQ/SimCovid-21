extends Node2D

var bar_red = preload("res://assets/barHorizontal_red.png")
var bar_green = preload("res://assets/barHorizontal_green.png")
var bar_yellow = preload("res://assets/barHorizontal_yellow.png")

export (float) var multiplier = 1

onready var healthbar = $HealthBar

func initialize(timer:Timer, progress_multiplier:float):
	multiplier = progress_multiplier
	timer.connect("timeout", self, "_update_value")

func _update_value():
	healthbar.value += 1 * multiplier
	_update_healthbar()

func _update_healthbar():
	healthbar.texture_progress = bar_green
	if healthbar.value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if healthbar.value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
