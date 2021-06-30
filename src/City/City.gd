extends Control

onready var bar_names = {
	'Cultural': [$Cine, $Cafe],
	'Economico': [$Negocios],
	'Salud': [$Hospital, $CasaDeGobierno],
	'Social': [$Chori, $Bar],
	'Protesta': [$Ruedas, $Basurero]
}

onready var protests = {
	'Cultural': false,
	'Economico': false,
	'Salud': false,
	'Social': false
}

func low_effect_city(category, value):
	var buildings = bar_names[category]
	beggin_protest(category)
	buildings.apagar
	
func high_effect_city(category, value):
	var buildings = bar_names[category]
	stop_protest(category)
	buildings.prender
	
func beggin_protest(category):
	var animate = bar_names['Protesta']
	if protests.values().has(true):
		#empeorar (hacer mas visible) animacion de tacho y ruedas
		for a in animate:
			a.animar
	else:
		#que aparezcan los tachos y ruedas
		for a in animate:
			a.aparecer
	protests[category] = true
	
func stop_protest(category):
	var animate = bar_names['Protesta']
	if protests.values().has(true):
		#mejorar(hacer menos visible) animacion de tacho y ruedas
		for a in animate:
			a.desanimar
	else:
		#que aparezcan los tachos y ruedas
		for a in animate:
			a.desparecer
	protests[category] = false
