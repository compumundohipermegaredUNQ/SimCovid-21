extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup
onready var clock = $Clock
onready var pedestrian_spawner = $PedestrianSpawner
onready var background = $Background
export (float) var seconds_per_day = 15
var round_number= 1

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
	clock.set_seconds_per_day(seconds_per_day)

func set_multipliers(multipliers):
	healt_bar_group.set_multipliers(multipliers)

func get_percentages():
	return healt_bar_group.get_percentages()

func restart_round(multipliers):
	round_number += 1
	healt_bar_group.reset_remaining_attempts()
	clock.set_round(round_number)
	var consequence = 0.1 * round_number
	var consequence_multipliers = {
		'Cultural': multipliers.Cultural * consequence,
		'Economia': multipliers.Economia * consequence,
		'Salud': multipliers.Salud * consequence,
		'Social': multipliers.Social * consequence
	}
	set_multipliers(consequence_multipliers)

func restart_game():
	pass
#	CardsDatabaseDeck.firstRound = true
#	CardsDatabaseDeck.restart_game()
#	healt_bar_group.restart_game()
#	clock.restart_game()
#	_ready()
