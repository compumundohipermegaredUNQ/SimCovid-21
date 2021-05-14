extends MarginContainer

#onready var title = $Card/Texts/Align/Title/CenterContainer/TitleLabel
#onready var label = $Card/Texts2/Text/CenterContainer/TextLabel

var cards_deck
var card_type
var card_multiplier

func initialize(type, title, text, multiplier, deck):
	cards_deck = deck
	card_type = type
	card_multiplier = multiplier
	$Card/Texts/Align/Title/CenterContainer/TitleLabel.text = title
	$Card/Texts2/Text/CenterContainer/TextLabel.text = text

func _on_CheckButton_pressed() -> void:
	cards_deck.checked(card_type, card_multiplier)
	call_deferred("_remove")


func _on_XButton_pressed() -> void:
	cards_deck.checked(card_type, -card_multiplier)
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()
