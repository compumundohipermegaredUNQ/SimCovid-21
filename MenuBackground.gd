extends Panel

onready var help_container = $HelpContainer
onready var input_container = $InputContainer

func _on_Start_pressed():
	input_container.show()

func _on_Help_pressed():
	help_container.show()

func _on_Back_pressed():
	help_container.hide()

func _on_ContinueButton_pressed():
	self.hide()

func _on_Input_text_changed(name):
	print(name)
	CardsDatabaseDeck.set_user_name(name)
