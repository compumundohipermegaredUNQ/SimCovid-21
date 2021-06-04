extends Node

onready var card_scene = preload("res://src/Card/CardBase.tscn")

#Multipliers order Cultural, Economico, Salud, Social
#[0.0, 0.0, 0.0, 0.0]

var firstRound = true
var current_deck
var current_used_deck
var main

const INFO_DECK = {
	'Introduccion': ["Sos el nuevo encargado de la ciudad.\n Debes aceptar decisiones o rechazarlas, estas tendrán un efecto inamovible por 15 días, así que elegí bien.\n Espero que hayas entendido por que quieras o no vamos a empezar", [0.0, 0.0, 0.0, 0.0]],
	'RoundResume': ["Resumen", "estadísticas"]
}

const INITIAL_DECK = {
	"Cultural": ['Las cartas con la categoría "Cultural"\n determinarán si tus ciudadanos aprenderán algo u olvidarán todo lo aprendido', [0.05, 0.01, -0.05, 0.03]],
	"Economico": ['Las cartas con la categoría "Economico"\n determinarán si lo que te importa es solo la plata', [0.02, 0.05, -0.2, 0.01]],
	"Salud": ['Las cartas con la categoría "Salud"\n determinarán si es un salvese quien pueda en el fin del mundo ', [0.02, -0.06, 0.04, 0.03]],
	"Social": ['Las cartas con esta categoría "Social"\n determinarán que tan mal o bien queres tratar a tus ciudadanos', [0.03, 0.02, -0.05, 0.05]]
}

# Remaining attempts -> Frase
const BAD_EVENTS_FRASES = {
	1: "Último intento\nMás no te puedo ayudar.",
	2: "Segundo intento\nLa gente te va a bancar solo una vez más eh.",
	3: "Primer intento\nHay que levantar esa barra.\nUn error lo tiene cualquiera, no?"
}

const GAME_OVER_CARDS = {
	"Cultural": ['Lograste tu cometido. Según las últimas encuentas\n a la gente, 2+2 = 5', [0.0, 0.0, 0.0, 0.0]],
	"Economico": ['Y si, perdiste. Destruiste la economía (chocolate por la noticia)\n En un momento así, solo se puede reir.', [0.0, 0.0, 0.0, 0.0]],
	"Salud": ['Decidiste vacunar a tu perro así que se te desbordaron los hospitales\n', [0.0, 0.0, 0.0, 0.0]],
	"Social": ['Te censuraron tu Twitter, Instagram, Facebook, MySpace y Fotolog\n', [0.0, 0.0, 0.0, 0.0]]
}

var RANDOM_DECK = {

	"Cultural": [
		["Cerrar Escuelas\n--------------------\n\n Los docentes a las aulas... virtuales", [-0.19, 0.0, 0.07, -0.04]],
		["Prohibir Deportes\n--------------------\n\n Excepto las canchitas de fulbo 5", [-0.15, 0.0, 0.06, -0.06]],
		["Prohibir Actividades al Aire Libre\n--------------------\n\n Adiós runners", [-0.17, 0.0, 0.05, -0.08]],
	],

	"Economico": [
		["Planes Sociales\n--------------------\n\n Al país se lo saca laburando?", [0.0, -0.17, 0.02, 0.06]],
		["Reducir Impuestos\n--------------------\n\n Vas a dar una mano al pueblo, estás seguro?", [-0.03, -0.19, -0.04, 0.07]],
		["Libre Comercio\n--------------------\n\n Aduana quién te conoce", [0.04, -0.14, 0.1, -0.03]],
	],

	"Salud": [
		["Ayuda a Esenciales\n--------------------\n\n Y no, los políticos no entramos acá", [0.0, -0.07, 0.15, 0.04]],
		["Aumento de Investigación\n--------------------\n\n Es esto o tener fe de no salir hablando ruso", [0.03, -0.06, 0.17, 0.0]],
		["Inversión en Suplementos\n--------------------\n\n A traer mas barbijos, y enseñar como usarlos", [0.02, -0.08, 0.19, 0.03]],
		["La gente está triste\n--------------------\n\n ¿ Les dejamos ver a Tinelli ?", [-0.03, 0.02, 0.4, -0.01]]
	],

	"Social": [
		["Limitar Comercios\n--------------------\n\n A usar MercadoLibre y Rappi", [0.0, -0.08, 0.05, -0.04]],
		["Limitar Circulación\n--------------------\n\n No mas salidas, sólo clandestinas", [-0.02, -0.05, 0.06, -0.14]],
		["Prohibir Eventos\n--------------------\n\n Bienvenidos los Zoomples", [-0.04, 0.0, 0.05, -0.018]],
	]
}

var USED_RANDOM_DECK = {
	"Cultural": [],
	"Economico": [],
	"Salud": [],
	"Social": []
}

var GOOD_EVENT_DECK = {

	"Cultural": [
		["Cerrar Escuelas\n--------------------\n\n Los docentes a las aulas... virtuales", [-0.19, 0.0, 0.07, -0.04]],
		["Prohibir Deportes\n--------------------\n\n Excepto las canchitas de fulbo 5", [-0.15, 0.0, 0.06, -0.06]],
		["Prohibir Actividades al Aire Libre\n--------------------\n\n Adiós runners", [-0.17, 0.0, 0.05, -0.08]],
	],

	"Economico": [
		["Planes Sociales\n--------------------\n\n Al país se lo saca laburando?", [0.0, -0.17, 0.02, 0.06]],
		["Reducir Impuestos\n--------------------\n\n Vas a dar una mano al pueblo, estás seguro?", [-0.03, -0.19, -0.04, 0.07]],
		["Libre Comercio\n--------------------\n\n Aduana quién te conoce", [0.04, -0.14, 0.1, -0.03]],
	],

	"Salud": [
		["Ayuda a Esenciales\n--------------------\n\n Y no, los políticos no entramos acá", [0.0, -0.07, 0.15, 0.04]],
		["Aumento de Investigación\n--------------------\n\n Es esto o tener fe de no salir hablando ruso", [0.03, -0.06, 0.17, 0.0]],
		["Inversión en Suplementos\n--------------------\n\n A traer mas barbijos, y enseñar como usarlos", [0.02, -0.08, 0.19, 0.03]],
		["La gente está triste\n--------------------\n\n ¿ Les dejamos ver a Tinelli ?", [-0.03, 0.02, 0.4, -0.01]]
	],

	"Social": [
		["Limitar Comercios\n--------------------\n\n A usar MercadoLibre y Rappi", [0.0, -0.08, 0.05, -0.04]],
		["Limitar Circulación\n--------------------\n\n No mas salidas, sólo clandestinas", [-0.02, -0.05, 0.06, -0.14]],
		["Prohibir Eventos\n--------------------\n\n Bienvenidos los Zoomples", [-0.04, 0.0, 0.05, -0.018]],
	]
}

var USED_GOOD_EVENT_DECK = {
	"Cultural": [],
	"Economico": [],
	"Salud": [],
	"Social": []
}

var BAD_EVENT_DECK = {

	"Cultural": [
		["Cerrar Escuelas\n--------------------\n\n Los docentes a las aulas... virtuales", [-0.19, 0.0, 0.07, -0.04]],
		["Prohibir Deportes\n--------------------\n\n Excepto las canchitas de fulbo 5", [-0.15, 0.0, 0.06, -0.06]],
		["Prohibir Actividades al Aire Libre\n--------------------\n\n Adiós runners", [-0.17, 0.0, 0.05, -0.08]],
	],

	"Economico": [
		["Planes Sociales\n--------------------\n\n Al país se lo saca laburando?", [0.0, -0.17, 0.02, 0.06]],
		["Reducir Impuestos\n--------------------\n\n Vas a dar una mano al pueblo, estás seguro?", [-0.03, -0.19, -0.04, 0.07]],
		["Libre Comercio\n--------------------\n\n Aduana quién te conoce", [0.04, -0.14, 0.1, -0.03]],
	],

	"Salud": [
		["Ayuda a Esenciales\n--------------------\n\n Y no, los políticos no entramos acá", [0.0, -0.07, 0.15, 0.04]],
		["Aumento de Investigación\n--------------------\n\n Es esto o tener fe de no salir hablando ruso", [0.03, -0.06, 0.17, 0.0]],
		["Inversión en Suplementos\n--------------------\n\n A traer mas barbijos, y enseñar como usarlos", [0.02, -0.08, 0.19, 0.03]],
		["La gente está triste\n--------------------\n\n ¿ Les dejamos ver a Tinelli ?", [-0.03, 0.02, 0.4, -0.01]]
	],

	"Social": [
		["Limitar Comercios\n--------------------\n\n A usar MercadoLibre y Rappi", [0.0, -0.08, 0.05, -0.04]],
		["Limitar Circulación\n--------------------\n\n No mas salidas, sólo clandestinas", [-0.02, -0.05, 0.06, -0.14]],
		["Prohibir Eventos\n--------------------\n\n Bienvenidos los Zoomples", [-0.04, 0.0, 0.05, -0.018]],
	]
}

var USED_BAD_EVENT_DECK = {
	"Cultural": [],
	"Economico": [],
	"Salud": [],
	"Social": []
}

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

func get_types():
	return _get_deck().keys()

#Deck inicial para quincena
func set_initial_deck(optionalContent):
	current_deck = INITIAL_DECK.duplicate()
	var card
	if firstRound:
		card = _get_card_instance_from_info('Introduccion', INFO_DECK['Introduccion'])
		firstRound = false
	else:
		INFO_DECK['RoundResume'] = [optionalContent, [0.0, 0.0, 0.0, 0.0]]
		card = _get_card_instance_from_info('RoundResume', INFO_DECK['RoundResume'])
	return card

func _get_card_instance_from_info(card_type, card_info:Array):
	var card = card_scene.instance()
	card.initialize(card_type, card_info[0], card_info[1], main)
	return card

func get_next_initial_card():
	var card_type = _get_deck().keys().front()
	var card = _get_card_instance_from_info(card_type, _get_deck()[card_type])
	_get_deck().erase(card_type)
	return card

func has_more_initial_cards():
	return !_get_deck().keys().empty()

# Retorna una carta random de un tipo de carta random.
func get_random_card_and_type():
	_set_deck(RANDOM_DECK)
	_set_current_used_deck(USED_RANDOM_DECK)
	return _get_random_card(_get_random_type())

# Retorna un tipo de carta random
func _get_random_type():
	if get_types().empty():
		_restart_deck()
	return _get_random(get_types())

#Random de lista
func _get_random(list:Array):
	return list[randi() % list.size()]

# Retorna una carta del tipo solicitado del random deck y la mueve al used deck.
# Si la carta es la ultima de su tipo, elimina a dicho tipo del random deck
# El tipo de carta debe existir en el random deck
func _get_random_card(card_type:String, move_to_used = true):
	var cards = _get_deck()[card_type]
	var index = randi() % cards.size()
	var card_info = cards[index]
	cards.remove(index)
	if move_to_used:
		_get_used_deck()[card_type].append(card_info)
	if _get_deck()[card_type].empty():
		_get_deck().erase(card_type)
	return _get_card_instance_from_info(card_type, card_info)

# Retorna una carta random del tipo solicitado. Si no hay cartas de ese tipo disponibles
# en el random deck, se sacan del used deck.
func get_random_card_from_type(card_type:String, move_to_used = true):
	if get_types().has(card_type):
		return _get_random_card(card_type, move_to_used)
	else:
		var card_info = _get_random(_get_used_deck()[card_type])
		return _get_card_instance_from_info(card_type, card_info)

# Retorno carta random de evento negativo
func get_low_event_card_from_type(card_type:String, attempts:int):
	_set_deck(BAD_EVENT_DECK)
	_set_current_used_deck(USED_BAD_EVENT_DECK)
	var card = get_random_card_from_type(card_type)
	card.prepend_to_description(get_text_from_attempts(attempts))
	_set_deck(RANDOM_DECK)
	_set_current_used_deck(USED_RANDOM_DECK)
	return card

func get_good_event_card_from_type(card_type:String):
	_set_deck(GOOD_EVENT_DECK)
	_set_current_used_deck(USED_GOOD_EVENT_DECK)
	var card = get_random_card_from_type(card_type)
	_set_deck(RANDOM_DECK)
	_set_current_used_deck(USED_RANDOM_DECK)
	return card

func get_game_over_card(card_type):
	var card_info = GAME_OVER_CARDS[card_type]
	var card = card_scene.instance()
	card.initialize(card_type, card_info[0], card_info[1], main, true)
	return card

func _restart_deck():
	_set_deck(_get_used_deck().duplicate())
	for key in _get_used_deck().keys():
		_get_used_deck()[key] = []

func get_text_from_attempts(attemps:int):
	return BAD_EVENTS_FRASES[attemps]
