extends Panel
class_name AreaInfoEntry


@onready var label :RichTextLabel = $HBoxContainer/RichTextLabel
@onready var image :TextureRect = $HBoxContainer/TextureRect


func init(catchable :CatchableRes):
	label.text = catchable.name
	image.texture = catchable.image
