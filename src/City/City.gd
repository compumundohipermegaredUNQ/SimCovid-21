extends Node

var cultural
var economia
var salud
var social
var protesta

var bar_names

func _ready():
	bar_names = {
		'Cultural': $Animations/CulturaAnimation,
		'Economico': $Animations/EconomiaAnimation,
		'Salud': $Animations/SaludAnimation,
		'Social': $Animations/SocialAnimation,
		'Protesta': $Animations/ProtestaAnimation
	}

func initialize():
	bar_names = {
		'Cultural': $Animations/CulturaAnimation,
		'Economico': $Animations/EconomiaAnimation,
		'Salud': $Animations/SaludAnimation,
		'Social': $Animations/SocialAnimation,
		'Protesta': $Animations/ProtestaAnimation
	}

onready var protests = {
	'Cultural': false,
	'Economico': false,
	'Salud': false,
	'Social': false
}

func low_effect_city(category, _value):
	bar_names[category].play("BadEvent")
	beggin_protest(category)

func normal_city(category, _value):
	for names in bar_names.keys():
		if name == 'Cultural':
			$CulturaAnimation.stop()
		if name == 'Economico':
			$EconomiaAnimation.stop()
		if name == 'Salud':
			$SaludAnimation.stop()
		if name == 'Social':
			$SocialAnimation.stop()
	stop_protest(category)

func high_effect_city(category, _value):
	bar_names[category].play("goodEvent")
	beggin_protest(category)
	stop_protest(category)

func beggin_protest(category):
	if protests.values().has(true):
		#empeorar (hacer mas visible) animacion de tacho y ruedas
		var exponential = 1 - protests.values().count(true) * 0.2
		$ProtestaAnimation.play("Picarla", -1, exponential, false)
	else:
		#que aparezcan los tachos y ruedas
		$ProtestaAnimation.play("Protest")
		$ProtestaAnimation.play("Picarla")
	protests[category] = true

func stop_protest(category):
	if protests.values().has(true):
		#mejorar (hacer mas visible) animacion de tacho y ruedas
		var exponential = 1 - protests.values().count(true) * 0.2
		$ProtestaAnimation.play("Picarla", -1, exponential, false)
	else:
		#que desaparezcan los tachos y ruedas
		bar_names["Protesta"].play("Gendarmeria")
	protests[category] = false
