extends Control


@export var binary_code :String

@onready var grid := $MarginContainer/GridContainer


func _ready() -> void:
	_clear_grid()
	_init_grid_code()


func _clear_grid() -> void:
	for child in grid.get_children():
		grid.remove_child(child)


func _init_grid_code() -> void:
	for character in binary_code:
		var texture_node = _create_texture_rect(character)
		grid.add_child(texture_node)


func _create_texture_rect(character :String) -> TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(12, 25)
	var canvas_texture = CanvasTexture.new()
	canvas_texture.specular_texture = CompressedTexture2D.new()
	texture_rect.texture = canvas_texture
	
	if character == "1":
		texture_rect.modulate = Color.GREEN
	elif character == "0":
		texture_rect.modulate = Color.BLACK
	else:
		texture_rect.modulate = Color(0,0,0,0)
	
	return texture_rect
