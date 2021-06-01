extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup
onready var clock = $Clock

func _ready():
	DeckOfCards.initialize(self, timer)
	$DeckOfCards.scale.x = 2
	$DeckOfCards.scale.y = 2
	
func _startGame(multipliers):
	clock.initialize(timer)
	# Esto eventualmente se elegirá desde el menú antes de arrancar
	healt_bar_group.initialize(timer, clock, multipliers)
	clock.set_seconds_per_day(15)

func set_multipliers(multipliers):
	healt_bar_group.set_multipliers(multipliers)

func get_percentages():
	return healt_bar_group.get_percentages()

func restart_round():
	#Agregar Restart de quincena
	pass
