extends Node2D

export (PackedScene) var cardScene

var parent
var initial_deck = CardsDatabaseDeck.get_initial_deck()
var cardNumber = 0
var multipliers = {
	'Social': 1,
	'Cultural': 0.5,
	'Economico': -0.5,
	'Salud': -1
}

func initialize(main):
	parent = main
	getNextCard()
	
func getNextCard():
	castCard(initial_deck[cardNumber])
	cardNumber += 1

func castCard(card):
	var card_instance = cardScene.instance()
	card_instance.initialize(card[0], card[1], card[2], self, parent)
	parent.add_child(card_instance)

func checked(multiplier):
	multipliers.Social += multiplier[0]
	multipliers.Cultural += multiplier[1]
	multipliers.Economico += multiplier[2]
	multipliers.Salud += multiplier[3]
	if (cardNumber == 13):
		parent._startGame(multipliers)
	else:
		getNextCard()
