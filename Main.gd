extends Node

onready var timer = $Timer
onready var health_bar_scene := preload("res://HealthBar.tscn")

func _ready():
	var healthbar1 = health_bar_scene.instance()
	var healthbar2 = health_bar_scene.instance()
	var healthbar3 = health_bar_scene.instance()
	healthbar1.initialize(timer, -2)
	healthbar2.initialize(timer, 1)
	healthbar3.initialize(timer, 2)
	add_child(healthbar1)
	add_child(healthbar2)
	add_child(healthbar3)
	healthbar1.set_position(Vector2(50,50))
	healthbar2.set_position(Vector2(50,80))
	healthbar3.set_position(Vector2(50,110))
