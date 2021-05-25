extends Node2D

export (PackedScene) var cardScene

var parent
var cardNumber = 0
var multipliers = {
	'Social': 1,
	'Cultural': 0.5,
	'Economico': -0.5,
	'Salud': -1
}

func initialize(main):
	parent = main
	getNextInitialCard()
	
func getNextInitialCard():
	var card = CardsDatabaseDeck.getNextInitialCard()
	parent.add_child(card)

func checked(multiplier):
	multipliers.Social += multiplier[0]
	multipliers.Cultural += multiplier[1]
	multipliers.Economico += multiplier[2]
	multipliers.Salud += multiplier[3]
	if CardsDatabaseDeck.has_more_initial_cards():
		parent._startGame(multipliers)
	else:
		getNextInitialCard()

func raise_card(card_type):
	print("Levantar carta de tipo " + card_type)
