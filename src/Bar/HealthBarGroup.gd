extends Control

onready var cultural_bar = $BottomPanel/HBoxContainer/Cultural
onready var economia_bar = $BottomPanel/HBoxContainer/Economico
onready var salud_bar = $BottomPanel/HBoxContainer/Salud
onready var social_bar = $BottomPanel/HBoxContainer/Social
onready var overall_bar = $TopPanel/HBoxContainer/OverallBar

var rng
var global_timer
var pedestrian_spawner

onready var bar_names = {
	'cultural_bar': cultural_bar,
	'economia_bar': economia_bar,
	'salud_bar': salud_bar,
	'social_bar': social_bar
}

var cultural_weight = 0.1
var economia_weight = 0.3
var salud_weight = 0.4
var social_weight = 0.2

func initialize(timer:Timer, clock:Node2D, multipliers, spawner, main_node, city):
	pedestrian_spawner = spawner
	cultural_bar.initialize(timer, clock, multipliers['Cultural'], main_node, city)
	economia_bar.initialize(timer, clock, multipliers['Economia'], main_node, city)
	salud_bar.initialize(timer, clock, multipliers['Salud'], main_node, city)
	social_bar.initialize(timer, clock, multipliers['Social'], main_node, city)
	_update_overall_value()
	timer.connect("timeout", self, "_update_overall_value")
	rng = RandomNumberGenerator.new()

func _update_overall_value():
	pedestrian_spawner.set_salud_current_value(salud_bar.get_healthbar_value())

	if (cultural_bar.get_healthbar_value() < 20):
		salud_weight -= 0.01
		economia_weight -= 0.01
		cultural_weight += 0.02

	if (economia_bar.get_healthbar_value() < 40):
		salud_weight -= 0.01
		social_weight -= 0.01
		economia_weight += 0.02

	if (salud_bar.get_healthbar_value() < 50):
		salud_weight += 0.03
		economia_weight -= 0.01
		social_weight -= 0.01
		cultural_weight -= 0.01

	if (social_bar.get_healthbar_value() < 30):
		salud_weight -= 0.01
		social_weight += 0.02
		cultural_weight -= 0.01

	cultural_weight = clamp(cultural_weight, 0.1, 0.3)
	economia_weight = clamp(economia_weight, 0.1, 0.5)
	salud_weight = clamp(salud_weight, 0.1, 0.6)
	social_weight = clamp(social_weight, 0.1, 0.4)

	var overall_value = cultural_bar.get_healthbar_value() * cultural_weight + economia_bar.get_healthbar_value() * economia_weight + salud_bar.get_healthbar_value() * salud_weight + social_bar.get_healthbar_value() * social_weight
	overall_bar.set_healthbar_value(overall_value)

func get_percentages():
	var percentages = []
	percentages.append(cultural_bar.get_healthbar_value())
	percentages.append(economia_bar.get_healthbar_value())
	percentages.append(salud_bar.get_healthbar_value())
	percentages.append(social_bar.get_healthbar_value())
	return percentages

func set_multipliers(multipliers):
	cultural_bar.set_multiplier(multipliers['Cultural'])
	economia_bar.set_multiplier(multipliers['Economia'])
	salud_bar.set_multiplier(multipliers['Salud'])
	social_bar.set_multiplier(multipliers['Social'])

func set_badevent_effect (card_type, effects):
	for bar in bar_names.values():
		if bar.label == card_type:
			bar.set_healthbar_value(bar.get_healthbar_value() + effects[0])
			bar.actualize_attempts()
		else:
			var newMulti = bar.get_multiplier() + effects[1]
			bar.set_multiplier(newMulti)

func set_badevent_nouse(card_type):
	for bar in bar_names.values():
		if bar.label == card_type:
			bar.actualize_fase_attempt()

func set_goodevent_effect(card_type, effects):
	for bar in bar_names.values():
		if bar.label == card_type:
			bar.set_healthbar_value(bar.get_healthbar_value() + effects[0])

func reset_remaining_attempts():
	cultural_bar.reset_remaining_attempts()
	economia_bar.reset_remaining_attempts()
	salud_bar.reset_remaining_attempts()
	social_bar.reset_remaining_attempts()

func restart_game():
	cultural_bar.restart()
	economia_bar.restart()
	salud_bar.restart()
	social_bar.restart()

func get_percentage_by_name(bar_name):
	return bar_names[bar_name].get_value()

func _get_max_best_or_worst_dict():
	return {
		cultural_bar.get_max_value() + 0.001: 'cultural_bar',
		economia_bar.get_max_value() + 0.002: 'economia_bar',
		salud_bar.get_max_value() + 0.003: 'salud_bar',
		social_bar.get_max_value() + 0.004: 'social_bar'
	}

func _get_index_from_random(random):
	if random > 40:
		return 3
	elif random > 20:
		return 2
	elif random > 10:
		return 1
	else:
		return 0

func _get_position_from_random():
	rng.randomize()
	var random = rng.randi_range(0, 100)
	return _get_index_from_random(random)

func get_best_or_worst_bar():
	var max_values = _get_max_best_or_worst_dict()
	print(max_values)
	var max_values_sorted = max_values.keys()
	max_values_sorted.sort()
	print(max_values_sorted)
	var max_value = max_values_sorted[_get_position_from_random()]
	var best_or_worst_bar = max_values[max_value]
	return [best_or_worst_bar, bar_names[best_or_worst_bar].get_value()]
