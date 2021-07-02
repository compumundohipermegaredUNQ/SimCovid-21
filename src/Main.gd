extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup
onready var clock_label = $HealthBarGroup/TopPanel/HBoxContainer/ClockContainer/Clock
onready var fase_label = $HealthBarGroup/TopPanel/HBoxContainer/FaseContainer/Fase
onready var clock = $Clock
onready var pedestrian_spawner = $PedestrianSpawner
onready var background = $Background
onready var game_over_screen = $GameOverScreen
onready var economic_video = $GameOverScreen/VBoxContainer/TV/Economic
onready var cultural_video = $GameOverScreen/VBoxContainer/TV/Cultural
onready var health_video = $GameOverScreen/VBoxContainer/TV/Health
onready var social_video = $GameOverScreen/VBoxContainer/TV/Social
onready var fade_animation = $Fade/FadeAnimation
onready var text_animation = $GameOverScreen/VBoxContainer/Text/TextAnimation
onready var game_over_text = $GameOverScreen/VBoxContainer/Text/GameOverText
onready var background_music = $Background/BackgroundMusic
onready var city = $Background/CITY

export (float) var seconds_per_day = 15
var round_number= 1
var game_over_card_type

func _ready():
	$DeckOfCards.scale.x = 2
	$DeckOfCards.scale.y = 2
	
func _startGame(multipliers):
	clock.initialize(timer, pedestrian_spawner, clock_label, fase_label)
	background.initialize(clock)
	# Esto eventualmente se elegirá desde el menú antes de arrancar
	pedestrian_spawner.initialize(timer, self, healt_bar_group)
	healt_bar_group.initialize(timer, clock, multipliers, pedestrian_spawner, self, city)
	clock.set_seconds_per_day(seconds_per_day)

func set_multipliers(multipliers):
	healt_bar_group.set_multipliers(multipliers)

func set_goodevent_effect(card_type, effects):
	healt_bar_group.set_goodevent_effect(card_type, effects)
	
func set_badevent_effect(card_type, effects, used):
	if(used):
		healt_bar_group.set_badevent_effect(card_type, effects)
	else:
		healt_bar_group.set_badevent_nouse(card_type)

func get_percentages():
	return healt_bar_group.get_percentages()

func restart_round(multipliers):
	round_number += 1
	healt_bar_group.reset_remaining_attempts()
	clock.set_round(round_number)
	var consequence = 0.1 * round_number
	var consequence_multipliers = {
		'Cultural': multipliers.Cultural * consequence,
		'Economia': multipliers.Economia * consequence,
		'Salud': multipliers.Salud * consequence,
		'Social': multipliers.Social * consequence
	}
	set_multipliers(consequence_multipliers)

func restart_game():
	pass
#	CardsDatabaseDeck.firstRound = true
#	CardsDatabaseDeck.restart_game()
#	healt_bar_group.restart_game()
#	clock.restart_game()
#	_ready()

func _on_ContinueButton_pressed():
	city.initialize()
	DeckOfCards.initialize(self, timer, city)

func game_over(card_type):
	# workaround horrible al no poder eliminar a las personas del arbol de nodos
	for c in get_children():
		if c.has_method("hide_pedestrian"):
			c.hide_pedestrian()
	background_music.stop()
	timer.stop()
	$Fade.show()
	game_over_card_type = card_type
	fade_animation.play("fade_in")

func start_video():
	var game_over_phrase = CardsDatabase.GAME_OVER_PHRASES[game_over_card_type] + CardsDatabase.GAME_OVER_RESTART_PHRASE
	game_over_text.text = game_over_phrase
	match game_over_card_type:
		"Salud":
			health_video.show()
			health_video.play()
		"Economico":
			economic_video.show()
			economic_video.play()
		"Cultural":
			cultural_video.show()
			cultural_video.play()
		"Social":
			social_video.show()
			social_video.play()
	text_animation.play("typewriter")
	game_over_text.show()

func _on_FadeAnimation_animation_finished(anim_name):
	if anim_name == "fade_in":
		game_over_screen.show()
		fade_animation.play("fade_out")
	else:
		start_video()
