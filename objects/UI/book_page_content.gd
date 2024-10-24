extends MarginContainer
class_name IdentificationPage


@onready var btn_fish_image = $VBoxContainer/HBoxContainer/BtnFishImage
@onready var picture = $VBoxContainer/HBoxContainer/BtnFishImage/PictureFish
@onready var name_label = $VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var size_label = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Size
@onready var habitat = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Habitat
@onready var description = $VBoxContainer/Description

var identification_catchable :IdentificationCatchable = null
var is_page_right :bool = false

signal btn_fish_clicked(IdentificationPage)


func init(catchable :IdentificationCatchable, page_right :bool):
	identification_catchable = catchable
	name_label.text = identification_catchable.name
	size_label.text = identification_catchable.size
	habitat.text = identification_catchable.habitat
	description.text = identification_catchable.description
	is_page_right = page_right
	picture.texture = catchable.get_picture()


func set_selected_catchable(catchable :CatchableRes) -> void:
	identification_catchable.selected_catchable = catchable
	picture.texture = catchable.image


func _on_btn_fish_image_pressed() -> void:
	btn_fish_clicked.emit(self)
