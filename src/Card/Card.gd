extends Control

# El valor representativo de la barra es la posición del hijo en la que se
# encuentra en el panel de escenas de HealthBarGroup, por ejemplo "Social" es el
# hijo que están en la posición 3. 
# No es la mejor práctica, pero no se me ocurrió otra manera de acceder a las
# escenas hijas de las barras

const scene_numbers_bars = {
	"Cultural": 0,
	"Economico": 1,
	"Salud": 2,
	"Social": 3,
}
const colors = {
	"Economico": Color(1, 0.090196, 0.090196, 0.75),
	"Salud": Color(0.30508, 0.886719, 0.040699, 0.75),
	"Social": Color(0.040699, 0.391004, 0.886719, 0.75),
	"Cultural": Color(0.860281, 0.886719, 0.040699, 0.75)
}
var card_type
var card_efects
var bar_group
var actual_bar
var game_over
var main_node
var animation
var shadow

func initialize(type, title, description, efects, main, has_lost = false) -> void:
	animation = $AnimationPlayer
	shadow = $Shadow
	shadow.hide()
	card_type = type
	print(card_type)
	card_efects = efects
	bar_group = main.get_child(4)
	$TextureRect/TitleLabel.text = title
	$TextureRect/TextLabel.text = description
	_set_color_by_type(type)
	game_over = has_lost
	main_node = main

func _ready() -> void:
	var card = $TextureRect
	var border = $ColorRect
	var shadow = $Shadow
	var viewport_size_y = get_viewport().get_visible_rect().size.y
	var project_size_y = ProjectSettings.get_setting("display/window/size/height")

	var desired_size = (card.rect_size.y * viewport_size_y) / project_size_y
	var scale_factor = (card.rect_scale.y * desired_size) / card.rect_size.y

	card.rect_scale = Vector2(scale_factor, scale_factor)
	border.rect_scale = Vector2(scale_factor, scale_factor)
	shadow.rect_scale = Vector2(scale_factor, scale_factor)
	var difference = (card.rect_size.y - desired_size) / 2
	card.rect_position += Vector2(difference, difference)
	border.rect_position += Vector2(difference, difference)
	shadow.rect_position += Vector2(difference, difference)

func _on_CheckButton_pressed() -> void:
	if game_over:
		main_node.restart_game()
	else:
		DeckOfCards.checked(card_type, card_efects, true)
		_update_if_exists_actual_bar()
		call_deferred("_remove")
		main_node.get_node('sfx').get_node("Si").play()

func _on_XButton_pressed() -> void:
	DeckOfCards.checked(card_type, card_efects, false)
	_update_if_exists_actual_bar()
	call_deferred("_remove")
	main_node.get_node('sfx').get_node("No").play()

func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()

func feedback() -> void:
	if scene_numbers_bars.keys().has(card_type):
		actual_bar = bar_group.get_child(1).get_child(0).get_child(scene_numbers_bars[card_type])
	if actual_bar:
		actual_bar.change_textlabel()

func _update_if_exists_actual_bar() -> void:
	if actual_bar:
		actual_bar.update_state()

func prepend_to_description(title:String, description:String):
	$TextureRect/TitleLabel.text = $TextureRect/TitleLabel.text.insert(0, title)
	$TextureRect/TextLabel.text = $TextureRect/TextLabel.text.insert(0, description)

func _on_CheckButton_ready() -> void:
	self.feedback()

func _on_XButton_ready() -> void:
	self.feedback()

func _set_texture_blue():
	$TextureRect.texture = load('res://assets/Card/panel_blue.png')
	$TextureRect/CheckButton.texture_normal = load('res://assets/Card/iconCheck_grey.png')
	$TextureRect/CheckButton.texture_pressed = load('res://assets/Card/iconCheck_bronze.png')
	$TextureRect/CheckButton.texture_hover = load('res://assets/Card/iconCheck_beige.png')
	$TextureRect/CheckButton.texture_focused = load('res://assets/Card/iconCheck_bronze.png')
	$TextureRect/XButton.texture_normal = load('res://assets/Card/iconCross_grey.png')
	$TextureRect/XButton.texture_pressed = load('res://assets/Card/iconCross_bronze.png')
	$TextureRect/XButton.texture_hover = load('res://assets/Card/iconCross_beige.png')
	$TextureRect/XButton.texture_focused = load('res://assets/Card/iconCross_bronze.png')

func _set_texture_brown():
	$TextureRect.texture = load('res://assets/Card/panel_brown.png')
	$TextureRect/TitleLabel.set("custom_colors/font_color",Color(0.141176, 0.066667, 0.031373)) #Color(0.90,0.63,0.49,1.00)
	$TextureRect/TextLabel.set("custom_colors/font_color",Color(0.254902, 0.180392, 0.145098)) #Color(0.65,0.59,0.56,1.00)

func _set_texture_beigeLight():
	$TextureRect.texture = load('res://assets/Card/panel_beigeLight.png')
	""" $TextureRect/CheckButton.texture_normal = load('res://assets/Card/iconCheck_grey.png')
	$TextureRect/CheckButton.texture_pressed = load('res://assets/Card/iconCheck_bronze.png')
	$TextureRect/CheckButton.texture_hover = load('res://assets/Card/iconCheck_beige.png')
	$TextureRect/CheckButton.texture_focused = load('res://assets/Card/iconCheck_bronze.png')
	$TextureRect/XButton.texture_normal = load('res://assets/Card/iconCross_grey.png')
	$TextureRect/XButton.texture_pressed = load('res://assets/Card/iconCross_bronze.png')
	$TextureRect/XButton.texture_hover = load('res://assets/Card/iconCross_beige.png')
	$TextureRect/XButton.texture_focused = load('res://assets/Card/iconCross_bronze.png')
 """
func _set_color_by_type(type):
	var color_rect = $ColorRect
	if colors.has(type):
		shadow.show()
		animation.play("shiny")
		color_rect.modulate = colors[type]

func _unset_visible_border():
	$ColorRect.visible = false

func _set_visible_border():
	$ColorRect.visible = true
