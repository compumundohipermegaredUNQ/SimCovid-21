extends Node2D

export (PackedScene) var PedestrianScene

onready var rng = RandomNumberGenerator.new()
onready var screenSize = get_viewport().get_visible_rect().size
onready var min_y_position = screenSize.y * 0.76
onready var max_y_position = screenSize.y * 0.9
onready var x_positions = [screenSize.x + 40, -10.0]
const nightfall_movement = 0.3
const sunrise_movement = 1
var movement_percentage = 0.3
var salud_bar_value = 0.5
var timer
var main

func initialize(main_timer:Timer, main_node:Node):
	timer = main_timer
	main = main_node
	timer.connect("timeout", self, "spawn_pedestrian")

func spawn_pedestrian():
	randomize()
	if randf() < movement_percentage:
		var person = PedestrianScene.instance()
		person.initialize()
		person.set_random_animation(is_sick())
		person.set_position_and_movement_direction(get_random_position())
		main.add_child(person)

func get_random_position() -> Vector2:
	randomize()
	var y_position = rng.randf_range(min_y_position, max_y_position)
	var x_position = x_positions[randi() % x_positions.size()]
	return Vector2(x_position, y_position)

func set_nightfall_movement():
	movement_percentage = nightfall_movement

func set_sunrise_movement():
	movement_percentage = sunrise_movement

func set_salud_current_value(salud_value):
	salud_bar_value = salud_value / 100

func is_sick():
	randomize()
	return randf() > salud_bar_value
