extends Node

var bar_names

onready var protests = {
	'Cultural': false,
	'Economico': false,
	'Salud': false,
	'Social': false
}

func initialize():
	bar_names = {
		'Cultural': $Animations/CulturaAnimation,
		'Economico': $Animations/EconomiaAnimation,
		'Salud': $Animations/SaludAnimation,
		'Social': $Animations/SocialAnimation,
		'Protesta': $Animations/ProtestaAnimation
	}

func low_effect_city(category, _value):
	bar_names[category].play("BadEvent")
	beggin_protest(category)

func normal_city(category, _value):
	bar_names[category].stop()
	if protests[category]:
		stop_protest(category)

func high_effect_city(category, _value):
	bar_names[category].play("GoodEvent")
	beggin_protest(category)


func beggin_protest(category):
	var exponential = 1 + protests.values().count(true) * 0.2
	if ! protests.values().has(true):
		#que aparezcan los tachos y ruedas
		bar_names["Protesta"].play("Protest")
		print($Basurero.rect_position)
	bar_names["Protesta"].play("Picarla", -1, exponential, false)
	protests[category] = true	


func stop_protest(category):
	protests[category] = false
	if protests.values().has(true):
		#mejorar (hacer mas visible) animacion de tacho y ruedas
		var exponential = 1 - protests.values().count(true) * 0.2
		bar_names["Protesta"].play("Picarla", -1, exponential, false)
	else :
		#que desaparezcan los tachos y ruedas
		bar_names["Protesta"].play("Gendarmeria")
