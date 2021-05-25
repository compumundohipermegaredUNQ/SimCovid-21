extends Node2D

signal low_bar(bar_type)

var bar_red = preload("res://assets/Bar/barHorizontal_red.png")
var bar_green = preload("res://assets/Bar/barHorizontal_green.png")
var bar_yellow = preload("res://assets/Bar/barHorizontal_yellow.png")

export (float) var multiplier = 1
export (String) var label = ""
export (float) var percentage = 1

onready var healthbar = $HealthBar
onready var healthbar_textlabel = $HealthBarLabel

var global_clock
var speed_multiplier

func initialize(timer:Timer, clock:Node2D, deck_multiplier):
	speed_multiplier = 1
	multiplier = deck_multiplier
	global_clock = clock
	global_clock.connect("speed_updated", self, "_set_speed_multiplier")
	_update_value()
	timer.connect("timeout", self, "_update_value")
	self.connect("low_bar", DeckOfCards, "raise_card")

func set_value(value:float):
	healthbar.value = value
	_update_healthbar()

func get_value():
	return healthbar.value * percentage

func _ready():
	healthbar_textlabel.set_text(label)

# Es un tema para que discutamos entre todos
# Idea: Si queremos que 1 día sean 20s (eventualmente), serían 1.2hs por segundo. 
# Eso sería una partida en vel. normal. Por lo tanto, "tiene sentido" que la velocidad sean
# las horas por segundo.

func _set_speed_multiplier(hours_per_second):
	speed_multiplier = hours_per_second

func _is_low():
	return healthbar.value < healthbar.max_value * 0.30

func _update_value():
	healthbar.value = healthbar.value + speed_multiplier * multiplier
	if _is_low():
		emit_signal("low_bar", healthbar_textlabel)
	_update_healthbar()

func _update_healthbar():
	healthbar.texture_progress = bar_green
	if healthbar.value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if healthbar.value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
