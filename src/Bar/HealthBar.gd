extends Control

signal low_bar(bar_type, attempts)
signal high_bar(bar_type)
signal game_over(bar_type)
signal low_effect_city(bar_type, value)
signal normal_city(bar_type, value)
signal high_effect_city(bar_type, value)

var bar_red = preload("res://assets/Bar/barHorizontal_red.png")
var bar_green = preload("res://assets/Bar/barHorizontal_green.png")
var bar_yellow = preload("res://assets/Bar/barHorizontal_yellow.png")
var neutro = preload("res://assets/Bar/checkbox_example.png")
var positive = preload("res://assets/Bar/checkbox2_example.png")
var negative = preload("res://assets/Bar/checkbox3_example.png")

export (float) var multiplier = 0
export (String) var label = ""
export (float) var percentage = 1

#onready var healthbar = $HealthBar 
onready var healthbar_textlabel = $HealthBarLabel
onready var healthbar = $ProgressBar
onready var good_event_decider = GoodEventDecider
onready var box = $TextureRect

var global_clock
var speed_multiplier
var remaining_ticks_before_emit = 10
var remaining_attempts = 3
var fase_attempt = true

func initialize(timer:Timer, clock:Node2D, deck_multiplier, main_node, city):
	good_event_decider.set_timer(timer)
	speed_multiplier = 1
	multiplier = deck_multiplier
	global_clock = clock
	global_clock.connect("speed_updated", self, "_set_speed_multiplier")
	_update_value()
	timer.connect("timeout", self, "_update_value")
	self.connect("low_bar", DeckOfCards, "raise_low_card")
	self.connect("high_bar", DeckOfCards, "raise_high_card")
	self.connect("game_over", main_node, "game_over")
	self.connect("low_effect_city", city, "low_effect_city")
	self.connect("high_effect_city", city, "high_effect_city")
	self.connect("normal_city", city, "normal_city")

func set_healthbar_value(value:float):
	healthbar.value = value
	_update_healthbar()

func get_healthbar_value():
	return healthbar.value

func set_multiplier(deck_multiplier):
	multiplier = deck_multiplier
	
func get_multiplier():
	return multiplier

func get_value():
	return healthbar.get_value()

func _ready():
	healthbar_textlabel.set_text(label)

func _set_speed_multiplier(hours_per_second):
	speed_multiplier = hours_per_second

func _is_low():
	return healthbar.value < healthbar.max_value * 0.30

func _is_high():
	return healthbar.value > healthbar.max_value * 0.70

func _update_value():
	healthbar.value = healthbar.value + speed_multiplier * multiplier
	if healthbar.value == 0:
		emit_signal("game_over", healthbar_textlabel.text)
	remaining_ticks_before_emit = clamp(remaining_ticks_before_emit-1, 0, 10)
	affect_city()
	if _can_emit():
		if _is_low() && _can_emit_low_event() && _is_bar_decreasing():
			_restart_emit_count()
			emit_signal("low_bar", healthbar_textlabel.text, remaining_attempts)
		if !_is_at_max_value() && _is_high() && GoodEventDecider.can_emit():
			emit_signal("high_bar", healthbar_textlabel.text)
	_update_healthbar()

func affect_city():
	if get_value() < 40:
		emit_signal("low_effect_city", healthbar_textlabel.text, healthbar.value)
	elif get_value() > 65:
		emit_signal("high_effect_city", healthbar_textlabel.text, healthbar.value)
	else:
		emit_signal("normal_city", healthbar_textlabel.text, healthbar.value)

func actualize_attempts():
	remaining_attempts -= 1
	actualize_fase_attempt()

func actualize_fase_attempt():
	fase_attempt = false

func _is_at_max_value():
	return healthbar.value == healthbar.max_value

func _can_emit():
	return remaining_ticks_before_emit == 0

func _can_emit_low_event() -> bool:
	return remaining_attempts != 0 && fase_attempt

func _is_bar_decreasing() -> bool:
	return multiplier < 0

func restart_attempts():
	remaining_attempts = 3

func _restart_emit_count():
	remaining_ticks_before_emit = 10

func _update_healthbar():
	healthbar.texture_progress = bar_green
	if healthbar.value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if healthbar.value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	if _is_bar_decreasing():
		box.texture = negative
	else:
		box.texture = positive
		

func change_textlabel():
	healthbar_textlabel.clear()
	healthbar_textlabel.append_bbcode("[wave amp=25 freq=10][color=blue]"+label+"[/color][/wave]")

func update_state():
	healthbar_textlabel.set_text(label)

func reset_remaining_attempts():
	fase_attempt = true

func restart():
	healthbar.value = 50
	restart_attempts()
	_restart_emit_count()

# Si la barra tiene un valor mayor a 50, me da ese valor.
# Si es menor, le resto ese valor a 100. La idea es siempre tener valores
# mayores a 50
func get_max_value():
	return healthbar.value if healthbar.value > 50 else 100 - healthbar.value
