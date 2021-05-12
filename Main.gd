extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup
onready var clock = $Clock
onready var deck_of_cards = $DeckOfCards

func _ready():
	deck_of_cards.initialize(self)
	
func _startGame():
	clock.initialize(timer)
	# Esto eventualmente se elegirá desde el menú antes de arrancar
	healt_bar_group.initialize(timer, clock)
	clock.set_seconds_per_day(5)
