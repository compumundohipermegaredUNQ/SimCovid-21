extends Node

onready var rng = RandomNumberGenerator.new()

const TICK_COUNT = 15

var global_timer;
var remaining_ticks_before_emit = TICK_COUNT
var good_event_percentage_chances = 0.7

func set_timer(timer:Timer):
	if !global_timer:
		global_timer = timer
		global_timer.connect("timeout", self, "_update_can_emit")

func _update_can_emit():
	remaining_ticks_before_emit = clamp(remaining_ticks_before_emit-1, 0, TICK_COUNT)

func _restart_emit_count():
	remaining_ticks_before_emit = TICK_COUNT

func can_emit():
	if remaining_ticks_before_emit == 0:
		rng.randomize()
		var random = rng.randf()
		var can_emit = random <= good_event_percentage_chances
		_restart_emit_count()
		return can_emit
	
