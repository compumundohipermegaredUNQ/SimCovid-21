extends TextureProgress

signal low_bar(bar_type, attempts)
signal high_bar(bar_type)
signal game_over(bar_type)

var bar_red = preload("res://assets/Bar/barHorizontal_red.png")
var bar_green = preload("res://assets/Bar/barHorizontal_green.png")
var bar_yellow = preload("res://assets/Bar/barHorizontal_yellow.png")
var neutro = preload("res://assets/Bar/checkbox_example.png")
var positive = preload("res://assets/Bar/checkbox2_example.png")
var negative = preload("res://assets/Bar/checkbox3_example.png")

const colors = {
	"Economico": Color(1, 0.090196, 0.090196, 0.75),
	"Salud": Color(0.30508, 0.886719, 0.040699, 0.75),
	"Social": Color(0.040699, 0.391004, 0.886719, 0.75),
	"Cultural": Color(0.860281, 0.886719, 0.040699, 0.75)
}

export (float) var multiplier = 0
export (String) var label = ""
export (float) var percentage = 1

onready var healthbar_textlabel = $HealthBarLabel
onready var good_event_decider = GoodEventDecider
onready var box = $TextureRect
onready var bar_boder = $BarBorder
onready var animation = $AnimationPlayer

var global_clock
var speed_multiplier
var remaining_ticks_before_emit = 10
var remaining_attempts = 3
var fase_attempt = true

func initialize(timer:Timer, clock:Node2D, deck_multiplier, main_node):
	bar_boder.modulate = colors[healthbar_textlabel.text]
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

func set_healthbar_value(value:float):
	self.value = value
	_update_healthbar()

func get_healthbar_value():
	return self.value

func set_multiplier(deck_multiplier):
	multiplier = deck_multiplier
	
func get_multiplier():
	return multiplier

func _ready():
	healthbar_textlabel.set_text(label)

func _set_speed_multiplier(hours_per_second):
	speed_multiplier = hours_per_second

func _is_low():
	return self.value < self.max_value * 0.30

func _is_high():
	return self.value > self.max_value * 0.70

func _update_value():
	self.value = self.value + speed_multiplier * multiplier
	if self.value < 1:
		emit_signal("game_over", healthbar_textlabel.text)
	remaining_ticks_before_emit = clamp(remaining_ticks_before_emit-1, 0, 10)
	if _can_emit():
		if _is_low() && _can_emit_low_event() && _is_bar_decreasing():
			_restart_emit_count()
			emit_signal("low_bar", healthbar_textlabel.text, remaining_attempts)
		if !_is_at_max_value() && _is_high() && GoodEventDecider.can_emit():
			emit_signal("high_bar", healthbar_textlabel.text)
	_update_healthbar()

func actualize_attempts():
	remaining_attempts -= 1
	actualize_fase_attempt()

func actualize_fase_attempt():
	fase_attempt = false

func _is_at_max_value():
	return self.value == self.max_value

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
	self.texture_progress = bar_green
	if self.value < self.max_value * 0.7:
		self.texture_progress = bar_yellow
	if self.value < self.max_value * 0.35:
		self.texture_progress = bar_red
	if _is_bar_decreasing():
		box.texture = negative
	else:
		box.texture = positive

func _play_animation():
	animation.play("shine")

func _stop_animation():
	animation.stop()

func change_textlabel():
#	_play_animation()
	healthbar_textlabel.clear()
	healthbar_textlabel.append_bbcode("[wave amp=25 freq=10][color=blue]"+label+"[/color][/wave]")

func update_state():
#	_stop_animation()
	healthbar_textlabel.set_text(label)

func reset_remaining_attempts():
	fase_attempt = true

func restart():
	self.value = 50
	restart_attempts()
	_restart_emit_count()

# Si la barra tiene un valor mayor a 50, me da ese valor.
# Si es menor, le resto ese valor a 100. La idea es siempre tener valores
# mayores a 50
func get_max_value():
	return self.value if self.value > 50 else 100 - self.value
