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
	CardsHandler.set_main(parent)
	parent.add_child(CardsHandler.set_initial_deck(''))
	
func get_next_initial_card():
	var card = CardsHandler.get_next_initial_card()
	parent.add_child(card)

func checked(card_type, effects, positive):
	local_deck.pop_front()
	apply_effects(card_type, effects, positive)
	if card_type == 'Introduccion':
		CardsHandler._set_tutorial(positive)
	elif ! local_deck.empty():
		parent.add_child(local_deck.front())
#	elif CardsHandler.has_more_initial_cards():
#		get_next_initial_card()
	elif game_started:
		parent.set_multipliers(multipliers)
		main_timer.start()
	else:
		game_started = true
		parent._startGame(multipliers)
		main_timer.start()

func apply_effects(card_type, effects, positive):
	if (effects.size() == 4):
		if(!positive):
			effects = [-effects[0], -effects[1], -effects[2], -effects[3]]
		print(multipliers)
		var index = 0
		for m in multipliers:
			multipliers[m] += effects[index]
			multipliers[m] = clamp(multipliers[m], -0.3, 0.3)
			index += 1
		print(multipliers)
	elif(effects.size() == 2):
		parent.set_badevent_effect(card_type, effects, positive)
	elif (effects.size() == 1):
		parent.set_goodevent_effect(card_type, effects)
		
func add_to_local_deck(card):
	main_timer.stop()
	if local_deck.empty():
		parent.add_child(card)
	local_deck.append(card)

func raise_card():
	var card = CardsHandler.get_random_card_and_type(CardsDatabase.RANDOM_DECK, CardsDatabase.USED_RANDOM_DECK)
	add_to_local_deck(card)

func raise_low_card(card_type, attempts):
	var card = CardsHandler.get_low_event_card_from_type(card_type, attempts)
	add_to_local_deck(card)

func raise_high_card(card_type):
	var card = CardsHandler.get_good_event_card_from_type(card_type)
	add_to_local_deck(card)

func game_over_card(card_type):
	var card = CardsHandler.get_game_over_card(card_type)
	add_to_local_deck(card)

func status_bars():
	var percentages = parent.get_percentages()
	return ["Resumen de la Quincena", "Los porcentajes andan en:" + "\n" + "Cultural" + str(percentages[0])  +  "\n" +  "Economia:" + str(percentages[1]) + "\n" +  "Salud:" + str(percentages[2]) + "\n" + "Social" + str(percentages[3]), [0.0, 0.0, 0.0, 0.0]]

func _on_Clock_morning():
	raise_card()

func _on_Clock_quincena():
	restart_round()
	CardsHandler.set_initial_deck(status_bars())

func restart_round():
	parent.restart_round(multipliers)
