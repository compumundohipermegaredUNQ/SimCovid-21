extends Node2D

var cards
var parent

func initialize(main):
	parent = main
	cards = self.get_children()
	
func _physics_process(_delta):	
	cards = self.get_children()
	if cards.empty():
		parent._startGame()
