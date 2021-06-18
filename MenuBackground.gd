extends Panel

onready var help_container = $HelpContainer
onready var input_container = $InputContainer

var user_name

func _on_Start_pressed():
	input_container.show()

func _on_Help_pressed():
	help_container.show()

func _on_Back_pressed():
	help_container.hide()

func _on_ContinueButton_pressed():
	PedestrianDatabase.set_user_name(user_name)
	self.hide()

func _on_Input_text_changed(name):
	user_name = name
