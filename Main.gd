extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup
onready var clock = $Clock

func _ready():
	clock.initialize(timer)
	# Esto eventualmente se elegirá desde el menú antes de arrancar
	healt_bar_group.initialize(timer, clock)
	clock.set_seconds_per_day(5)
