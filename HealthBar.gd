extends Node2D

var bar_red = preload("res://assets/barHorizontal_red.png")
var bar_green = preload("res://assets/barHorizontal_green.png")
var bar_yellow = preload("res://assets/barHorizontal_yellow.png")

export (float) var multiplier = 1
export (String) var label = ""
export (float) var percentage = 1

onready var healthbar = $HealthBar
onready var healthbar_textlabel = $HealthBarLabel

func set_timer(timer:Timer):
	timer.connect("timeout", self, "_update_value")

func set_value(value:float):
	healthbar.value = value
	_update_healthbar()

func get_value():
	return healthbar.value * percentage

func _ready():
	healthbar_textlabel.set_text(label)

func _update_value():
	healthbar.value += 1 * multiplier
	_update_healthbar()

func _update_healthbar():
	healthbar.texture_progress = bar_green
	if healthbar.value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if healthbar.value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
