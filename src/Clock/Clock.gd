extends Node2D

onready var clock_label = $ClockLabel

export (float) var seconds_per_day = 5

var day_count = 1
var hour_count = 0
var hours_per_second

signal day_change
signal speed_updated
signal morning
signal quincena

func morningCard():
	if(hour_count == 8 ):
		emit_signal("morning")

func initialize(timer:Timer):
	set_seconds_per_day(seconds_per_day)
	_do_update()
	timer.connect("timeout", self, "_update")
	self.connect("morning", DeckOfCards, "raise_card")
	self.connect("quincena", DeckOfCards, "_on_Clock_quincena")

func set_seconds_per_day(seconds_in_a_day:float):
	hours_per_second = round(24/seconds_in_a_day)
	emit_signal("speed_updated", hours_per_second)

func _update():
	hour_count += hours_per_second
	if (hour_count > 24):
		emit_signal("day_change")
		day_count += 1
		if(day_count == 15):
			emit_signal("quincena")
		hour_count -= 24
	morningCard()
	_do_update()

func _do_update():
	var text = str("Dia ", day_count, ": ", hour_count, ":00hs")
	clock_label.set_text(text)

