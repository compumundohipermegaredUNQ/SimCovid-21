extends Node

onready var card_scene = preload("res://src/Card/CardBase.tscn")

# Multipliers order Social, Economico, Cultural, Salud

var INITIAL_DECK = {
	"Introduccion": ["Sos el nuevo encargado de la ciudad, debes aceptar desiciones o rechazarlas, estas tendran un efecto inamovible por 15 dias, asi que elegi bien. Espero que hayas entendido por que quieras o no vamos a empezar", [0.0, 0.0, 0, 0.0]],
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
	]
}

var EVENT_DECK = {
	"Salud": [
		["La gente esta triste. ¿ Les dejamos ver a Tinelli ?", [0.0, 0.0, 0.0, 0.4]]
	]
}

var USED_DECK = {
	"Social": [],
	"Economico": [],
	"Cultural": [],
	"Salud": []
}

var current_deck = RANDOM_DECK

func get_next_initial_card():
	var card_type = INITIAL_DECK.keys().front()
	var card = _get_card_instance_from_info(card_type, INITIAL_DECK[card_type])
	INITIAL_DECK.erase(card_type)
	return card

func has_more_initial_cards():
	return !INITIAL_DECK.keys().empty()

func get_types():
	return _get_deck().keys()

# Retorna una carta random de un tipo de carta random.
func get_random_card_and_type():
	return _get_random_card(_get_random_type())

# Retorna una carta random del tipo solicitado. Si no hay cartas de ese tipo disponibles
# en el random deck, se sacan del used deck.
func get_random_card_from_type(card_type:String, move_to_used = true):
	if get_types().has(card_type):
		return _get_random_card(card_type, move_to_used)
	else:
		var card_info = _get_random(USED_DECK[card_type])
		return _get_card_instance_from_info(card_type, card_info)

func get_random_event_card_from_type(card_type:String):
	_set_deck(EVENT_DECK)
	var card = get_random_card_from_type(card_type, false)
	_set_deck(RANDOM_DECK)
	return card

func _set_deck(deck):
	current_deck = deck

func _get_deck():
	return current_deck

# Retorna un tipo de carta random
func _get_random_type():
	if get_types().empty():
		_restart_deck()
	return _get_random(get_types())

# Retorna una carta del tipo solicitado del random deck y la mueve al used deck.
# Si la carta es la ultima de su tipo, elimina a dicho tipo del random deck
# El tipo de carta debe existir en el random deck
func _get_random_card(card_type:String, move_to_used = true):
	var cards = _get_deck()[card_type]
	var index = randi() % cards.size()
	var card_info = cards[index]
	cards.remove(index)
	if move_to_used:
		USED_DECK[card_type].append(card_info)
	if _get_deck()[card_type].empty():
		_get_deck().erase(card_type)
	return _get_card_instance_from_info(card_type, card_info)

func _get_random(list:Array):
	return list[randi() % list.size()]

func _restart_deck():
	RANDOM_DECK = USED_DECK
	for type in USED_DECK.keys():
		USED_DECK[type] = []

func _get_card_instance_from_info(card_type, card_info:Array):
	var card = card_scene.instance()
	card.initialize(card_type, card_info[0], card_info[1])
	return card
