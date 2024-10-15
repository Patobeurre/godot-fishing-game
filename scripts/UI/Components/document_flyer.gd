extends Node


@onready var texture_rect = $MarginContainer/TextureRect


func fill_content(document :FlyerRes):
	texture_rect.texture = document.image
