extends Node2D

export (PackedScene) var cardScene

var parent
var main_timer
var cardNumber = 0
var game_started = false
var multipliers = {
	'Cultural': 0.02,
	'Economia': -0.06,
	'Salud': -0.1,
	'Social': 0.05
}

func initialize(main, timer):
	parent = main
	main_timer = timer
	CardsDatabaseDeck.set_main(parent)
	parent.add_child(CardsDatabaseDeck.set_initial_deck(''))
	
func get_next_initial_card():
	var card = CardsDatabaseDeck.get_next_initial_card()
	parent.add_child(card)

func checked(multiplier):
	print(multiplier)
	multipliers.Cultural += multiplier[0]
	multipliers.Economia += multiplier[1]
	multipliers.Salud += multiplier[2]
	multipliers.Social += multiplier[3]
	multipliers.Cultural = clamp(multipliers.Cultural, -0.3, 0.3)
	multipliers.Economia = clamp(multipliers.Economia, -0.3, 0.3)
	multipliers.Salud = clamp(multipliers.Salud, -0.3, 0.3)
	multipliers.Social = clamp(multipliers.Social, -0.3, 0.3)
	print(multipliers)
	if game_started:
		parent.set_multipliers(multipliers)
		main_timer.start()
	elif CardsDatabaseDeck.has_more_initial_cards():
		get_next_initial_card()
	else:
		game_started = true
		parent._startGame(multipliers)

func raise_card():
	main_timer.stop()
	var card = CardsDatabaseDeck.get_random_card_and_type()
	parent.add_child(card)

func raise_low_card(card_type):
	main_timer.stop()
	var card = CardsDatabaseDeck.get_low_event_card_from_type(card_type)
	parent.add_child(card)

func raise_high_card(card_type):
	main_timer.stop()
	var card = CardsDatabaseDeck.get_good_event_card_from_type(card_type)
	parent.add_child(card)

func status_bars():
	var percentages = parent.get_percentages()
	return "Resumen de la Quincena los porcentajes andan en:" + "\n" + "Cultural" + str(percentages[0])  +  "\n" +  "Economia:" + str(percentages[1]) + "\n" +  "Salud:" + str(percentages[2]) + "\n" + "Social" + str(percentages[3])

func _on_Clock_morning():
	raise_card()

func _on_Clock_quincena():
	main_timer.stop()
	restart_round()
	parent.add_child(CardsDatabaseDeck.set_initial_deck(status_bars()))

func restart_round():
	game_started = false
	parent.restart_round(multipliers)
