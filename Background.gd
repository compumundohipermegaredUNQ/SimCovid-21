extends Control

onready var sky = $Sky

var progress = 1.1
var will_sunrise = -1
var min_progress = 0
var max_progress = 1.1

func initialize(clock):
	clock.connect("begin_sunrise", self, "begin_sunrise")
	clock.connect("begin_nightfall", self, "begin_nightfall")

# 1.1 -> 0 sunrise
# 0 -> 1.1 nightfall
func _process(delta):
	progress = clamp(progress - will_sunrise * delta, min_progress, max_progress)
	# Evitamos setear constantemente el parametro del shader
	if (progress != min_progress || progress != max_progress):
		sky.material.set_shader_param("progress", progress)

func begin_sunrise():
	progress = max_progress
	will_sunrise = 1

func begin_nightfall():
	progress = min_progress
	will_sunrise = -1
