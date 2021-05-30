extends Node

onready var card_scene = preload("res://src/Card/CardBase.tscn")

#Multipliers order Social, Economico, Cultural, Salud
#[0.0, 0.0, 0.0, 0.0]

var firstRound = true
var current_deck
var current_used_deck

const INFO_DECK = {
	'Introduccion': ["Sos el nuevo encargado de la ciudad, debes aceptar desiciones o rechazarlas, estas tendran un efecto inamovible por 15 dias, asi que elegi bien. Espero que hayas entendido por que quieras o no vamos a empezar", [0.0, 0.0, 0.0, 0.0]],
	'RoundResume': ["Resumen", "estadisticas"]
}

const INITIAL_DECK = {
	"Social": ['Las cartas con esta categoria la afectaran principalmente, y decidiran que tan mal o bien queres tratar a tus ciudadanos', [0.05, 0.02, 0.03, -0.05]],
	"Economico": ['Las cartas con esta categoria la afectaran principalmente, y decidiran si lo que te importa es solo la plata', [0.01, 0.05, 0.02, -0.2]],
	"Cultural": ['Las cartas con esta categoria la afectaran principalmente, y decidiran si tus ciudadanos aprenderan algo o olvidaran todo lo aprendido', [0.03, 0.01, 0.05, -0.05]],
	"Salud": ['Las cartas con esta categoria la afectaran principalmente, y decidiran si es un salvese quien pueda en el fin del mundo ', [0.03, -0.06, 0.02, 0.04]]
}

var RANDOM_DECK = {
	"Social": [
		["Limitar Comercios: A usar MercadoLibre y Rappi", [-0.2, -0.08, 0, 0.04]],
		["Limitar Circulacion: No mas salidas, solo clandestinas", [-0.14, -0.05, -0.02, 0.06]],
		["Prohibir Eventos: Bienvenidos los Zoomples", [-0.18, 0, -0.04, 0.05]],
#		["Eventos", "Prohibir eventos masivos", 0.6],
	],

	"Economico": [
		["Planes Sociales: Al pais se lo saca laburando?", [0.6, -0.17, 0.0, 0.02]],
		["Reducir Impuestos: ", [0.07, -0.19, -0.03, -0.4]],
		["Libre Comercio: Aduana quien te conoce", [-0.03, -0.14, 0.04, 0.1]],
#		["Dolar", "Aumentar cepo", 0.3],
	],

	"Cultural": [
		["Cerrar Escuelas: Los docentes a las aulas... virtuales", [-0.04, 0.0, -0.19, 0.07]],
		["Prohibir Deportes: Excepto las canchitas de fulbo 5", [-0.06, 0.0, -0.15, 0.06]],
		["Prohibir Actividades al Aire Libre: Adios runners", [-0.08, 0.0, -0.17, 0.05]],
#		["Museos", "Cerrar museos", 0.4],
	],

	"Salud": [
		["Ayuda a Esenciales: Y no, los politicos no entramos aca", [0.04, -0.07, 0.0, 0.15]],
		["Aumento de Investigacion: Es esto o tener fe de no salir hablando ruso", [0.0, -0.06, 0.03, 0.17]],
		["Inversion en Suplmentos: A traer mas barbijos, y enseñar como usarlos", [0.03, -0.08, 0.02, 0.19]],
		["La gente esta triste. ¿ Les dejamos ver a Tinelli ?", [0.0, 0.0, 0.0, 0.4]]
#		["Vacunas", "Conseguir vacunas", 0.4]
	]
}

var USED_RANDOM_DECK = {
	"Social": [],
	"Economico": [],
	"Cultural": [],
	"Salud": []
}

var GOOD_EVENT_DECK = {
	"Social": [
		["Limitar Comercios: A usar MercadoLibre y Rappi", [-0.2, -0.08, 0, 0.04]],
		["Limitar Circulacion: No mas salidas, solo clandestinas", [-0.14, -0.05, -0.02, 0.06]],
		["Prohibir Eventos: Bienvenidos los Zoomples", [-0.18, 0, -0.04, 0.05]],
	],
	"Economico": [
		["Planes Sociales: Al pais se lo saca laburando?", [0.6, -0.17, 0.0, 0.02]],
		["Reducir Impuestos: ", [0.07, -0.19, -0.03, -0.4]],
		["Libre Comercio: Aduana quien te conoce", [-0.03, -0.14, 0.04, 0.1]],
	],
	"Cultural": [
		["Cerrar Escuelas: Los docentes a las aulas... virtuales", [-0.04, 0.0, -0.19, 0.07]],
		["Prohibir Deportes: Excepto las canchitas de fulbo 5", [-0.06, 0.0, -0.15, 0.06]],
		["Prohibir Actividades al Aire Libre: Adios runners", [-0.08, 0.0, -0.17, 0.05]],
	],
	"Salud": [
		["Ayuda a Esenciales: Y no, los politicos no entramos aca", [0.04, -0.07, 0.0, 0.15]],
		["Aumento de Investigacion: Es esto o tener fe de no salir hablando ruso", [0.0, -0.06, 0.03, 0.17]],
		["Inversion en Suplmentos: A traer mas barbijos, y enseñar como usarlos", [0.03, -0.08, 0.02, 0.19]],
		["La gente esta triste. ¿ Les dejamos ver a Tinelli ?", [0.0, 0.0, 0.0, 0.4]]
	]
}

var USED_GOOD_EVENT_DECK = {
	"Social": [],
	"Economico": [],
	"Cultural": [],
	"Salud": []
}

var BAD_EVENT_DECK = {
	"Social": [
		["Limitar Comercios: A usar MercadoLibre y Rappi", [-0.2, -0.08, 0, 0.04]],
		["Limitar Circulacion: No mas salidas, solo clandestinas", [-0.14, -0.05, -0.02, 0.06]],
		["Prohibir Eventos: Bienvenidos los Zoomples", [-0.18, 0, -0.04, 0.05]],
	],
	"Economico": [
		["Planes Sociales: Al pais se lo saca laburando?", [0.6, -0.17, 0.0, 0.02]],
		["Reducir Impuestos: ", [0.07, -0.19, -0.03, -0.4]],
		["Libre Comercio: Aduana quien te conoce", [-0.03, -0.14, 0.04, 0.1]],
	],
	"Cultural": [
		["Cerrar Escuelas: Los docentes a las aulas... virtuales", [-0.04, 0.0, -0.19, 0.07]],
		["Prohibir Deportes: Excepto las canchitas de fulbo 5", [-0.06, 0.0, -0.15, 0.06]],
		["Prohibir Actividades al Aire Libre: Adios runners", [-0.08, 0.0, -0.17, 0.05]],
	],
	"Salud": [
		["Ayuda a Esenciales: Y no, los politicos no entramos aca", [0.04, -0.07, 0.0, 0.15]],
		["Aumento de Investigacion: Es esto o tener fe de no salir hablando ruso", [0.0, -0.06, 0.03, 0.17]],
		["Inversion en Suplmentos: A traer mas barbijos, y enseñar como usarlos", [0.03, -0.08, 0.02, 0.19]],
		["La gente esta triste. ¿ Les dejamos ver a Tinelli ?", [0.0, 0.0, 0.0, 0.4]]
	]
}

var USED_BAD_EVENT_DECK = {
	"Social": [],
	"Economico": [],
	"Cultural": [],
	"Salud": []
}

#Getters & Setters
func _set_deck(deck):
	current_deck = deck

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
	card.initialize(card_type, card_info[0], card_info[1])
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
func get_low_event_card_from_type(card_type:String):
	_set_deck(BAD_EVENT_DECK)
	_set_current_used_deck(USED_BAD_EVENT_DECK)
	var card = get_random_card_from_type(card_type)
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

func _restart_deck():
	_set_deck(_get_used_deck())
	for key in _get_used_deck().keys():
		_get_used_deck()[key] = []
