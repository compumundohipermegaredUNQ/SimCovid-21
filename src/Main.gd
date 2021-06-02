extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup
onready var clock = $Clock
onready var pedestrian_spawner = $PedestrianSpawner
onready var background = $Background

func _ready():
	DeckOfCards.initialize(self, timer)
	$DeckOfCards.scale.x = 2
	$DeckOfCards.scale.y = 2
	
func _startGame(multipliers):
	clock.initialize(timer, pedestrian_spawner)
	background.initialize(clock)
	# Esto eventualmente se elegirá desde el menú antes de arrancar
	pedestrian_spawner.initialize(timer, self)
	healt_bar_group.initialize(timer, clock, multipliers, pedestrian_spawner)
	clock.set_seconds_per_day(15)

func set_multipliers(multipliers):
	healt_bar_group.set_multipliers(multipliers)
