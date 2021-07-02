extends Node

var bar_names
var tutorial

onready var protests = {
	'Cultural': false,
	'Economico': false,
	'Salud': false,
	'Social': false
}

func initialize():
	tutorial = $Animations/TutorialAnimation
	
	bar_names = {
		'Cultural': $Animations/CulturaAnimation,
		'Economico': $Animations/EconomiaAnimation,
		'Salud': $Animations/SaludAnimation,
		'Social': $Animations/SocialAnimation,
		'Protesta': $Animations/ProtestaAnimation,
	}

func tutorial_city(category):
	for k in bar_names.values():
		k.stop()
#	if bar_names.keys().has(category):
#		bar_names[category].play("Tutorial")
#	else:
#		tutorial.play("Tutorial")

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
