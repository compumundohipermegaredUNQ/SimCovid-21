extends Node2D

export (PackedScene) var cardScene

var parent
var main_timer
var cardNumber = 0
var game_started = false
var multipliers = {
	'Social': 0.05,
	'Cultural': 0.02,
	'Economico': -0.06,
	'Salud': -0.1
}

func initialize(main, timer):
	parent = main
	main_timer = timer
	get_next_initial_card()
	
func get_next_initial_card():
	var card = CardsDatabaseDeck.get_next_initial_card()
	parent.add_child(card)

func checked(multiplier):
	multipliers.Social += multiplier[0]
	multipliers.Cultural += multiplier[1]
	multipliers.Economico += multiplier[2]
	multipliers.Salud += multiplier[3]
	if game_started:
		parent.set_multipliers(multipliers)
		main_timer.start()
	elif CardsDatabaseDeck.has_more_initial_cards():
		get_next_initial_card()
	else:
		game_started = true
		parent._startGame(multipliers)

func raise_card(card_type):
	main_timer.stop()
	var card = CardsDatabaseDeck.get_random_event_card_from_type(card_type)
	parent.add_child(card)
