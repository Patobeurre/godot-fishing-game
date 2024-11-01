extends HBoxContainer
class_name IdentificationValidatedEntry


@onready var texture_image = $Image
@onready var name_label = $Name

var identified_catchable :IdentificationCatchable


func init(catchable :IdentificationCatchable):
	identified_catchable = catchable
	texture_image.texture = catchable.matching_catchable.image
	name_label.text = catchable.name
