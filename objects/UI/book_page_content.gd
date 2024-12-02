extends MarginContainer
class_name IdentificationPage


@onready var btn_fish_image = $VBoxContainer/HBoxContainer/BtnFishImage
@onready var picture = $VBoxContainer/HBoxContainer/BtnFishImage/PictureFish
@onready var name_label = $VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var size_label = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Size
@onready var habitat = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Habitat
@onready var description = $VBoxContainer/MarginContainer/Description
@onready var verified_image = $VBoxContainer/HBoxContainer/BtnFishImage/VerifiedImage

var identification_catchable :IdentifiedRes = null
var is_page_right :bool = false

signal btn_fish_clicked(IdentificationPage)


func _ready() -> void:
	SignalBus.validate_identification.connect(_on_identification_validated)


func init(identified_catchable :IdentifiedRes, page_right :bool):
	identification_catchable = identified_catchable
	name_label.text = "[b][i]" + identification_catchable.catchable.name + "[/i][/b]"
	size_label.text = "[img]res://sprites/UI/ruler.png[/img] " + tr(identification_catchable.catchable.size)
	habitat.text = "[img]res://sprites/UI/location.png[/img] " + tr(identification_catchable.catchable.habitat)
	description.text = identification_catchable.catchable.description
	is_page_right = page_right
	picture.texture = identification_catchable.get_picture()
	verified_image.visible = identification_catchable.is_correctly_identified


func set_selected_catchable(catchable :CatchableRes) -> void:
	if identification_catchable.is_correctly_identified:
		return
	identification_catchable.selected_catchable = catchable
	picture.texture = catchable.image


func _on_identification_validated():
	if FishingManager.verified_list.has(identification_catchable):
		verified_image.visible = true


func _on_btn_fish_image_pressed() -> void:
	if identification_catchable.is_correctly_identified:
		return
	btn_fish_clicked.emit(self)


func _on_texture_button_pressed() -> void:
	set_selected_catchable(IdentifiedRes.unknown_catchable)
