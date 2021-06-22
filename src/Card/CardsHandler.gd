extends Node

onready var card_scene = preload("res://src/Card/CardBase.tscn")

var firstRound = true
var initial_deck_empty
var current_deck
var current_used_deck
var main


#Getters & Setters
func _set_deck(deck):
	current_deck = deck

func set_main(parent):
	main = parent

func _get_deck():
	return current_deck

func _get_used_deck():
	return current_used_deck

func _set_current_used_deck(deck):
	current_used_deck = deck

func get_types(deck):
	return deck.keys()

#Deck inicial para quincena
func set_initial_deck(optionalContent):
	current_deck = CardsDatabase.INITIAL_DECK.duplicate()
	initial_deck_empty = false
	var card
	if firstRound:
		card = _get_card_instance_from_info('Introducción', CardsDatabase.INTRO_DECK['Introducción'])
		firstRound = false
	else:
		CardsDatabase.INTRO_DECK['RoundResume'] = optionalContent
		card = _get_card_instance_from_info('RoundResume', CardsDatabase.INTRO_DECK['RoundResume'])
	return card

func _get_card_instance_from_info(card_type, card_info:Array):
	var card = card_scene.instance()
	card.initialize(card_type, card_info[0], card_info[1], card_info[2], main)
	return card

func get_next_initial_card():
	var card_type = _get_deck().keys().front()
	var card = _get_card_instance_from_info(card_type, _get_deck()[card_type])
	_get_deck().erase(card_type)
	if _get_deck().keys().empty():
		initial_deck_empty = true
	return card

func has_more_initial_cards():
	return ! initial_deck_empty

# Retorna una carta random de un tipo de carta random.
func get_random_card_and_type(deck, usedDeck):
	var array = ["0","1","2"]
	var valor = array[randi() % array.size()]
	main.get_node('sfx').get_node("Mg").get_node(valor).play()
	return _get_random_card(deck, usedDeck, _get_random_type(deck, usedDeck))

# Retorna un tipo de carta random
func _get_random_type(deck, usedDeck):
	if get_types(deck).empty():
		_restart_deck(deck, usedDeck)
	return _get_random(get_types(deck))

#Random de lista
func _get_random(list:Array):
	return list[randi() % list.size()]

# Retorna una carta del tipo solicitado del random deck y la mueve al used deck.
# Si la carta es la ultima de su tipo, elimina a dicho tipo del random deck
# El tipo de carta debe existir en el random deck
func _get_random_card(deck, usedDeck, card_type:String, move_to_used = true):
	var cards = deck[card_type]
	var index = randi() % cards.size()
	var card_info = cards[index]
	cards.remove(index)
	if move_to_used:
		usedDeck[card_type].append(card_info)
	if deck[card_type].empty():
		deck.erase(card_type)
	return _get_card_instance_from_info(card_type, card_info)

# Retorna una carta random del tipo solicitado. Si no hay cartas de ese tipo disponibles
# en el random deck, se sacan del used deck.
func get_random_card_from_type(deck, usedDeck, card_type:String, move_to_used = true):
	if get_types(deck).has(card_type):
		return _get_random_card(deck, usedDeck, card_type, move_to_used)
	else:
		var card_info = _get_random(usedDeck[card_type])
		return _get_card_instance_from_info(card_type, card_info)

# Retorno carta random de evento negativo
func get_low_event_card_from_type(card_type:String, attempts:int):
	var card = get_random_card_from_type(CardsDatabase.BAD_EVENT_DECK, CardsDatabase.USED_BAD_EVENT_DECK, card_type)
	card.prepend_to_description(get_title_from_attempts(attempts), get_text_from_attempts(attempts))
	main.get_node('sfx').get_node("Intento").play()
	return card

func get_good_event_card_from_type(card_type:String):
	var card = get_random_card_from_type(CardsDatabase.GOOD_EVENT_DECK, CardsDatabase.USED_GOOD_EVENT_DECK, card_type)
	return card

func get_game_over_card(card_type):
	var card_info = CardsDatabase.GAME_OVER_CARDS[card_type]
	var card = card_scene.instance()
	card.initialize(card_type, card_info[0], card_info[1], card_info[2], main, true)
	main.get_node('sfx').get_node("Fail").play()
	return card

func _restart_deck(deck, usedDeck):
	for key in usedDeck.keys():
		deck[key] = usedDeck[key]
		usedDeck[key] = []

func get_text_from_attempts(attemps:int):
	return CardsDatabase.BAD_EVENTS_FRASES[attemps][1]

func get_title_from_attempts(attemps:int):
	return CardsDatabase.BAD_EVENTS_FRASES[attemps][0]