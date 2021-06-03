extends Node2D

onready var cultural_bar = $Cultural
onready var economia_bar = $Economico
onready var salud_bar = $Salud
onready var social_bar = $Social
onready var overall_bar = $OverallBar
var global_timer
var pedestrian_spawner


var cultural_weight = 0.1
var economia_weight = 0.3
var salud_weight = 0.4
var social_weight = 0.2

func initialize(timer:Timer, clock:Node2D, multipliers, spawner):
	pedestrian_spawner = spawner
	cultural_bar.initialize(timer, clock, multipliers['Cultural'])
	economia_bar.initialize(timer, clock, multipliers['Economia'])
	salud_bar.initialize(timer, clock, multipliers['Salud'])
	social_bar.initialize(timer, clock, multipliers['Social'])
	_update_overall_value()
	timer.connect("timeout", self, "_update_overall_value")

func _update_overall_value():
	pedestrian_spawner.set_salud_current_value(salud_bar.get_healthbar_value())

	if (cultural_bar.get_value() < 20):
		salud_weight -= 0.01
		economia_weight -= 0.01
		cultural_weight += 0.02

	if (economia_bar.get_value() < 40):
		salud_weight -= 0.01
		social_weight -= 0.01
		economia_weight += 0.02

	if (salud_bar.get_value() < 50):
		salud_weight += 0.03
		economia_weight -= 0.01
		social_weight -= 0.01
		cultural_weight -= 0.01

	if (social_bar.get_value() < 30):
		salud_weight -= 0.01
		social_weight += 0.02
		cultural_weight -= 0.01

	cultural_weight = clamp(cultural_weight, 0.1, 0.3)
	economia_weight = clamp(economia_weight, 0.1, 0.5)
	salud_weight = clamp(salud_weight, 0.1, 0.6)
	social_weight = clamp(social_weight, 0.1, 0.4)

	var overall_value = cultural_bar.get_value() * cultural_weight + economia_bar.get_value() * economia_weight + salud_bar.get_value() * salud_weight + social_bar.get_value() * social_weight
	overall_bar.set_value(overall_value)

func get_percentages():
	var percentages = []
	percentages.append(cultural_bar.get_value())
	percentages.append(economia_bar.get_value())
	percentages.append(salud_bar.get_value())
	percentages.append(social_bar.get_value())
	return percentages

func set_multipliers(multipliers):
	cultural_bar.set_multiplier(multipliers['Cultural'])
	economia_bar.set_multiplier(multipliers['Economia'])
	salud_bar.set_multiplier(multipliers['Salud'])
	social_bar.set_multiplier(multipliers['Social'])
