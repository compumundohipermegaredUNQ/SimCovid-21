extends Node

onready var timer = $Timer
onready var healt_bar_group = $HealthBarGroup

func _ready():
	healt_bar_group.initialize(timer)
