extends Node

enum {Social, Economico, Cultural, Salud}

const DATA = {
	Social:
		["Comercio", "Limitar Comercios"]
}

const INITIAL_DECK = {
	'Social': [
		["Comercio", "Limitar Comercios", 0.8],
		["Circulacion", "Prohibir salidas después de las 19hs", 0.6],
		["Eventos", "Prohibir eventos sociales", 0.4],
#		["Eventos", "Prohibir eventos masivos", 0.6],
	],
	'Economico': [
		["Planes", "Dar ayudas economicas", 0.4],
		["Impuestos", "Aumentar impuestos", 0.3],
		["Comercio", "Habilitar libre comercio", 0.4],
#		["Dolar", "Aumentar cepo", 0.3],
	],
	'Cultural': [
		["Escuelas", "Cerrar escuelas", 0.3],
		["Deportes", "Prohibir deportes", 0.2],
		["Deportes", "Prohibir runners", 0.1],
#		["Museos", "Cerrar museos", 0.4],
	],
	'Salud': [
		["Esenciales", "Dar apoyo a personal esencial", 0.4],
		["Investigacion", "Aumentar presupuesto en investigacion", 0.3],
		["Inversion", "Aumentar inversión en salud", 0.6],
#		["Vacunas", "Conseguir vacunas", 0.4],
	]
}

func get_initial_deck():
	return INITIAL_DECK
