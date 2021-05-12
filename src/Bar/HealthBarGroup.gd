extends Node2D

onready var economia_bar = $EconomiaBar
onready var salud_bar = $SaludBar
onready var cultural_bar = $CulturalBar
onready var social_bar = $SocialBar
onready var overall_bar = $OverallBar
var global_timer

func initialize(timer:Timer, clock:Node2D):
	economia_bar.initialize(timer, clock)
	salud_bar.initialize(timer, clock)
	cultural_bar.initialize(timer, clock)
	social_bar.initialize(timer, clock)
	_update_overall_value()
	timer.connect("timeout", self, "_update_overall_value")

func _update_overall_value():
	var overall_value = economia_bar.get_value() + salud_bar.get_value() + cultural_bar.get_value() + social_bar.get_value()
	overall_bar.set_value(overall_value)
