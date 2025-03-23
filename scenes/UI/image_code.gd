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
		var texture_node = _create_texture_rect(character == "1")
		grid.add_child(texture_node)


func _create_texture_rect(with_texture :bool) -> TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(12, 25)
	if with_texture:
		var canvas_texture = CanvasTexture.new()
		canvas_texture.specular_texture = CompressedTexture2D.new()
		texture_rect.texture = canvas_texture
	return texture_rect
