extends Node

enum {Social, Economico, Cultural, Salud}

#const DATA = {
#	Social:
#		["Comercio", "Limitar Comercios"]
#}

const INITIAL_DECK = {
	
		0: ["Introduccion", "Sos el nuevo encargado de la ciudad, debes aceptar desiciones o rechazarlas, estas tendran un efecto inamovible por 15 dias, asi que elegi bien. Espero que hayas entendido por que quieras o no vamos a empezar", [0.0, 0.0, 0, 0.0]],
	
		1: ['Social', "Limitar Comercios: A usar MercadoLibre y Rappi", [-0.2, -0.08, 0, 0.04]],
		5: ['Social', "Limitar Circulacion: No mas salidas, solo clandestinas", [-0.14, -0.05, -0.02, 0.06]],
		9: ['Social', "Prohibir Eventos: Bienvenidos los Zoomples", [-0.18, 0, -0.04, 0.05]],
#		["Eventos", "Prohibir eventos masivos", 0.6],

		2: ['Economico', "Planes Sociales: Al pais se lo saca laburando?", [0.6, -0.17, 0.0, 0.02]],
		6: ['Economico', "Reducir Impuestos: ", [0.07, -0.19, -0.03, -0.4]],
		10: ['Economico', "Libre Comercio: Aduana quien te conoce", [-0.03, -0.14, 0.04, 0.1]],
#		["Dolar", "Aumentar cepo", 0.3],

		3: ['Cultural', "Cerrar Escuelas: Los docentes a las aulas... virtuales", [-0.04, 0.0, -0.19, 0.07]],
		7: ['Cultural', "Prohibir Deportes: Excepto las canchitas de fulbo 5", [-0.06, 0.0, -0.15, 0.06]],
		11: ['Cultural', "Prohibir Actividades al Aire Libre: Adios runners", [-0.08, 0.0, -0.17, 0.05]],
#		["Museos", "Cerrar museos", 0.4],

		4: ['Salud', "Ayuda a Esenciales: Y no, los politicos no entramos aca", [0.04, -0.07, 0.0, 0.15]],
		8: ['Salud', "Aumento de Investigacion: Es esto o tener fe de no salir hablando ruso", [0.0, -0.06, 0.03, 0.17]],
		12: ['Salud', "Inversion en Suplmentos: A traer mas barbijos, y enseñar como usarlos", [0.03, -0.08, 0.02, 0.19]],
#		["Vacunas", "Conseguir vacunas", 0.4]
}

func get_initial_deck():
	return INITIAL_DECK
