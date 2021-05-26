extends MarginContainer

var initial_deck = CardsDatabaseDeck.get_initial_deck()
var cards_deck
var card_type
var card_multipliers
var parent
var bar_group
var actual_bar

func initialize(type, description, multipliers, deck, main):
	cards_deck = deck
	card_type = type
	card_multipliers = multipliers
	parent = main
	bar_group = parent.get_child(2)
	$Card/Texts/Align/Title/CenterContainer/TitleLabel.text = type
	$Card/Texts2/Text/CenterContainer/TextLabel.text = description

func _on_CheckButton_pressed() -> void:
	cards_deck.checked(card_multipliers)
	if actual_bar:
		actual_bar.update_state()
	call_deferred("_remove")


func _on_XButton_pressed() -> void:
	card_multipliers=[-card_multipliers[0], -card_multipliers[1], -card_multipliers[2], -card_multipliers[3]]
	cards_deck.checked(card_multipliers)
	if actual_bar:
		actual_bar.update_state()
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()

func _on_CheckButton_mouse_entered() -> void:
	self.feedback()

func feedback():
	match card_type:
		"Social":
			actual_bar = bar_group.get_child(3)
			print("Social ", card_multipliers[0])
		"Economico":
			actual_bar = bar_group.get_child(0)
			print("Economico ", card_multipliers[1])
		"Cultural":
			actual_bar = bar_group.get_child(2)
			print("Cultural ", card_multipliers[2])
		"Salud":
			actual_bar = bar_group.get_child(1)
			print("Salud ", card_multipliers[3])
	if actual_bar:
		actual_bar.change_color()


func _on_XButton_mouse_entered() -> void:
	self.feedback()
