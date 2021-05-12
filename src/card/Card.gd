extends MarginContainer

onready var cards_database = preload("res://src/card/CardsDatabase.gd")
export var health_bar: PackedScene
onready var card_info = cards_database.DATA[cards_database.get(card_name)]
var card_name = "Social"

func _ready() -> void:
	var card_size = rect_size
	$Card.scale *= card_size/$Card.texture.get_size()
	$Card/Texts/Align/Title/CenterContainer/TitleLabel.text = card_info[0]
	$Card/Texts2/Text/CenterContainer/TextLabel.text = card_info[1]
	print(card_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_CheckButton_pressed() -> void:
	# Debería pegarle a las barras cambiando su multiplicador
	call_deferred("_remove")


func _on_XButton_pressed() -> void:
	# Debería pegarle a las barras cambiando su multiplicador	
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()
