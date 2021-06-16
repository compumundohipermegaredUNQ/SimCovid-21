extends AnimatedSprite

export (float) var speed = 100

var rng
var animations
var direction = 1
var health_bar_group
var bar_names = ['cultural_bar', 'economia_bar', 'salud_bar', 'social_bar']

func initialize(health_bar_groups):
	rng = RandomNumberGenerator.new()
	animations = ["male_walk", "female_walk"]
	health_bar_group = health_bar_groups

func _move_to_right():
	direction = 1
	self.flip_h = 0

func _move_to_left():
	direction = -1
	self.flip_h = 1

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
	for bar_name in bar_names:
		print(bar_name, gender)
		var percentage = health_bar_group.get_percentage_by_name(bar_name)
		if percentage < 33:
			pedestrian = PedestrianDatabase.PEDESTRIANS.low[bar_name]
			self.play(pedestrian+'_'+gender)
		elif percentage > 66:
			pedestrian = PedestrianDatabase.PEDESTRIANS.high[bar_name]
			self.play(pedestrian+'_'+gender)
		else:
			self.play(gender)
		print(pedestrian+'_'+gender)
		pedestrian = ''
