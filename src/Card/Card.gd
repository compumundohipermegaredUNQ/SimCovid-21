extends MarginContainer

var card_type
var card_multipliers

func initialize(type, description, multipliers):
	card_type = type
	card_multipliers = multipliers
	$Card/Texts/Align/Title/CenterContainer/TitleLabel.text = type
	$Card/Texts2/Text/CenterContainer/TextLabel.text = description

func _on_CheckButton_pressed() -> void:
	DeckOfCards.checked(card_multipliers)
	call_deferred("_remove")


func _on_XButton_pressed() -> void:
	card_multipliers=[-card_multipliers[0], -card_multipliers[1], -card_multipliers[2], -card_multipliers[3]]
	DeckOfCards.checked(card_multipliers)
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()
