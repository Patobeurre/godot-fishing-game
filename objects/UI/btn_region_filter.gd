extends TextureButton
class_name ButtonRegionFilter


@onready var label :Label = $Label

@export var regions :Array[RegionRes] = []
@export var texture :Texture2D
@export var text_color :Color = Color.BLACK
@export var default_text :String = "All"


func _ready() -> void:
	texture_normal = texture
	label.add_theme_color_override("font_color", text_color)
	if not regions.is_empty():
		label.text = regions[0].name
	else:
		label.text = default_text


func get_regions() -> Array[RegionRes]:
	if button_pressed:
		return regions
	else:
		return []
