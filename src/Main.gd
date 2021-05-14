extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup
onready var clock = $Clock
onready var deck_of_cards = $DeckOfCards

func _ready():
	deck_of_cards.initialize(self)
	$DeckOfCards.scale.x = 2
	$DeckOfCards.scale.y = 2
	
func _startGame(multipliers):
	clock.initialize(timer)
	# Esto eventualmente se elegirá desde el menú antes de arrancar
	healt_bar_group.initialize(timer, clock, multipliers)
	clock.set_seconds_per_day(15)
