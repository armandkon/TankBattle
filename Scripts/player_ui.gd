extends CanvasLayer

class_name PlayerUI

@onready var life_bar = $MarginContainer/LifeBar
@onready var ammo_container = %AmmoContainer
@onready var ammo_left_label = %AmmoLeftLabel


var bullet_texture = preload("res://Sunny Land Collection Files/Packs/bullet_icon.png")

func set_life_bar_max_value(max_value: int):
	life_bar.max_value = max_value
	
func update_life_bar_value(life: int):
	life_bar.value = life

func set_max_ammo(max_ammo: int):
	for i in max_ammo:
		var ammo_texture_rect = TextureRect.new()
		ammo_texture_rect.texture = bullet_texture
		ammo_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		ammo_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		ammo_container.add_child(ammo_texture_rect)

func set_ammo_left(ammo_left: int):
	ammo_left_label.text = " /%d" % ammo_left
	
func bullet_shot(bullet_number: int):
	var bullet_count = ammo_container.get_child_count()
	var bullet_texture_rect = ammo_container.get_child(bullet_count - 1 - bullet_number)
	bullet_texture_rect.modulate = Color(Color.WHITE, .5)
	
func gun_reloaded(ammo_in_magazine: int, total_ammo_left: int):
	var bullet_count = ammo_container.get_child_count()
	
	for i in ammo_in_magazine:
		var bullet_texture_rect = ammo_container.get_child(bullet_count - 1 - i)
		bullet_texture_rect.modulate = Color(Color.WHITE)
	
	set_ammo_left(total_ammo_left)
