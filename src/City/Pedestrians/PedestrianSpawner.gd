extends Node2D

export (PackedScene) var PedestrianScene

onready var rng = RandomNumberGenerator.new()
onready var screenSize = get_viewport().get_visible_rect().size
onready var min_y_position = screenSize.y * 0.76
onready var max_y_position = screenSize.y * 0.9
onready var x_positions = [screenSize.x + 40, -10.0]

var timer
var main

func initialize(main_timer:Timer, main_node:Node):
	timer = main_timer
	main = main_node
	timer.connect("timeout", self, "spawn_pedestrian")

func spawn_pedestrian():
	var person = PedestrianScene.instance()
	person.initialize()
	person.set_random_animation()
	person.set_position_and_movement_direction(get_random_position())
	main.add_child(person)

func get_random_position() -> Vector2:
	randomize()
	var y_position = rng.randf_range(min_y_position, max_y_position)
	var x_position = x_positions[randi() % x_positions.size()]
	return Vector2(x_position, y_position)
