extends Panel

onready var help_container = $HelpContainer

func _on_Start_pressed():
	self.hide()

func _on_Help_pressed():
	help_container.show()

func _on_Back_pressed():
	help_container.hide()
