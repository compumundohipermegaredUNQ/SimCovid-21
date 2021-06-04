extends Node2D

export (PackedScene) var cardScene

var parent
var main_timer
var local_deck = []
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
	local_deck.pop_front()
	multipliers.Cultural += multiplier[0]
	multipliers.Economia += multiplier[1]
	multipliers.Salud += multiplier[2]
	multipliers.Social += multiplier[3]
	multipliers.Cultural = clamp(multipliers.Cultural, -0.3, 0.3)
	multipliers.Economia = clamp(multipliers.Economia, -0.3, 0.3)
	multipliers.Salud = clamp(multipliers.Salud, -0.3, 0.3)
	multipliers.Social = clamp(multipliers.Social, -0.3, 0.3)
	if ! local_deck.empty():
		parent.add_child(local_deck.front())
	elif CardsDatabaseDeck.has_more_initial_cards():
		get_next_initial_card()
	elif game_started:
		parent.set_multipliers(multipliers)
		main_timer.start()
	else:
		game_started = true
		parent._startGame(multipliers)

func add_to_local_deck(card):
	main_timer.stop()
	if local_deck.empty():
		parent.add_child(card)
	local_deck.append(card)

func raise_card():
	var card = CardsDatabaseDeck.get_random_card_and_type()
	add_to_local_deck(card)

func raise_low_card(card_type, attempts):
	var card = CardsDatabaseDeck.get_low_event_card_from_type(card_type, attempts)
	add_to_local_deck(card)

func raise_high_card(card_type):
	var card = CardsDatabaseDeck.get_good_event_card_from_type(card_type)
	add_to_local_deck(card)

func game_over_card(card_type):
	var card = CardsDatabaseDeck.get_game_over_card(card_type)
	add_to_local_deck(card)

func status_bars():
	var percentages = parent.get_percentages()
	return "Resumen de la Quincena los porcentajes andan en:" + "\n" + "Cultural" + str(percentages[0])  +  "\n" +  "Economia:" + str(percentages[1]) + "\n" +  "Salud:" + str(percentages[2]) + "\n" + "Social" + str(percentages[3])

func _on_Clock_morning():
	raise_card()

func _on_Clock_quincena():
	restart_round()
	var card = CardsDatabaseDeck.set_initial_deck(status_bars())
	add_to_local_deck(card)

func restart_round():
	parent.restart_round(multipliers)
