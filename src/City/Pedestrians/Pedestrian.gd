extends AnimatedSprite

export (float) var speed = 100

var rng
var animations
var direction = 1
var percentage
var pedestrian_bar_name
var bubble_speech
var bubble_speech_label

func initialize(bar_percentage, bar_name):
	rng = RandomNumberGenerator.new()
	animations = ["male_walk", "female_walk"]
	percentage = bar_percentage
	pedestrian_bar_name = bar_name
	bubble_speech = $BubbleSpeech
	bubble_speech_label = $BubbleSpeech/Label
	bubble_speech.hide()

func _move_to_right():
	direction = 1
	self.flip_h = 0
	bubble_speech.flip_h = 0
	bubble_speech.offset = Vector2(0,0)

func _move_to_left():
	direction = -1
	self.flip_h = 1
	bubble_speech.flip_h = 1
	bubble_speech.offset = Vector2(-400, 0)
	bubble_speech_label.set_position(Vector2(-739, -170))

func _process(delta):
	position.x += direction * speed * delta
	
func set_male_animation():
	self.play("male_walk")

func set_female_animation():
	self.play("female_walk")

func set_zombie_animation():
	self.play("zombie_walk")

func set_position_and_movement_direction(pos:Vector2):
	position = pos
	if pos.x > 0:
		_move_to_left()
	else:
		_move_to_right()
func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()

func set_random_animation():
	rng.randomize()
	var pedestrian = ''
	var gender = animations[randi() % animations.size()]
	if percentage < 33:
		pedestrian = PedestrianDatabase.PEDESTRIANS.low[pedestrian_bar_name]
		self.play(pedestrian+'_'+gender)
	elif percentage > 66:
		pedestrian = PedestrianDatabase.PEDESTRIANS.high[pedestrian_bar_name]
		self.play(pedestrian+'_'+gender)
	else:
		self.play(gender)
	print(pedestrian+'_'+gender)

func set_random_phrase():
	rng.randomize()
	if PedestrianDatabase.get_current_ticks() == 0:
		bubble_speech.show()
		var phrase = PedestrianDatabase.PHRASES[randi() % PedestrianDatabase.PHRASES.size()]
		if '{user_name}' in phrase:
			phrase = phrase.replace('{user_name}', PedestrianDatabase.get_user_name())
		bubble_speech_label.text = phrase
		PedestrianDatabase.restart_ticks()




