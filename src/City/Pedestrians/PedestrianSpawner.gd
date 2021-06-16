extends Node2D

export (PackedScene) var PedestrianScene

onready var rng = RandomNumberGenerator.new()
const nightfall_movement = 0.3
const sunrise_movement = 1
var health_bar_group
var min_y_position
var max_y_position
var y_position_diff
var x_positions
var movement_percentage = 0.3
var salud_bar_value = 0.5
var timer
var main

func initialize(main_timer:Timer, main_node:Node, health_bar_group2):
	timer = main_timer
	main = main_node
	health_bar_group = health_bar_group2
	timer.connect("timeout", self, "spawn_pedestrian")

func spawn_pedestrian():
	_set_position()
	randomize()
	if randf() < movement_percentage:
		var person = PedestrianScene.instance()
		var person_position = get_random_position()
		person.initialize(health_bar_group)
		person.set_random_animation()
		person.set_position_and_movement_direction(person_position)
		person.set_z_index(get_z_index_from_position(person_position.y))
		main.add_child(person)

func get_z_index_from_position(y_position):
	var pos = y_position_diff - (max_y_position - y_position)
	return int(pos * y_position_diff / 100)

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

func _set_position():
	var screenSize = get_viewport().get_visible_rect().size
	min_y_position = screenSize.y * 0.8
	max_y_position = screenSize.y - 110
	y_position_diff = max_y_position - min_y_position
	x_positions = [screenSize.x + 40, -10.0]
