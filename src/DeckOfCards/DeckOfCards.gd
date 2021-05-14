extends Node2D

export (PackedScene) var cardScene

var parent
var count = 12
var multipliers = {
	'Social': 0,
	'Cultural': 0,
	'Economico': 0,
	'Salud': 0
}

func initialize(main):
	parent = main
	var initial_deck = CardsDatabaseDeck.get_initial_deck()
	for type in initial_deck:
		for card in initial_deck[type]:
			var card_instance = cardScene.instance()
			card_instance.initialize(type, card[0], card[1], card[2], self)
			main.add_child(card_instance)

func checked(type, multiplier):
	multipliers[type] += multiplier
	self.count -= 1
	if (count == 0):
		parent._startGame(multipliers)
