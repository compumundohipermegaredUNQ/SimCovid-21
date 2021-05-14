extends Node2D

export (PackedScene) var cardScene

var parent
var count = 12
var multipliers = {
	'Social': 1,
	'Cultural': 0.5,
	'Economico': -0.5,
	'Salud': -1
}

func initialize(main):
	parent = main
	var initial_deck = CardsDatabaseDeck.get_initial_deck()
	for type in initial_deck:
		for card in initial_deck[type]:
			var card_instance = cardScene.instance()
			card_instance.initialize(type, card[0], card[1], self)
			main.add_child(card_instance)

func checked(type, multiplier):
	multipliers.Social += multiplier[0]
	multipliers.Cultural += multiplier[1]
	multipliers.Economico += multiplier[2]
	multipliers.Salud += multiplier[3]
	self.count -= 1
	if (count == 0):
		parent._startGame(multipliers)
