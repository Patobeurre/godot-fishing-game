extends MarginContainer


@onready var name_label = $VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var size_label = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Size
@onready var habitat = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Habitat
@onready var description = $VBoxContainer/Description

var identification_catchable :IdentificationCatchable = null


func init(catchable :IdentificationCatchable):
	identification_catchable = catchable
	name_label.text = identification_catchable.name
	size_label.text = identification_catchable.size
	habitat.text = identification_catchable.habitat
	description.text = identification_catchable.description
