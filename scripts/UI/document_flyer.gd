extends Node


@onready var texture_rect = $CenterContainer/TextureRect


func fill_content(document :FlyerRes):
	texture_rect.texture = document.image
