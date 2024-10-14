extends Node
class_name CollectedItem


@onready var image :TextureRect = $MarginContainer/HBoxContainer/PanelContainer/TextureRect
@onready var description :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel
@onready var lures :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/RichTextLabel2
@onready var locations :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/RichTextLabel2
@onready var periods_container = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/HBoxContainer

@onready var day_night_icon_scene = preload("res://objects/UI/DayNightIcon.tscn")

var collected_catchable :CollectedCatchable


func init(catchable :CollectedCatchable):
	collected_catchable = catchable
	update()


func update():
	image.texture = collected_catchable.catchable.image
	description.text = collected_catchable.catchable.description
	lures.text = ""
	for lure in collected_catchable.lure_used:
		lures.text += lure.name + ", "
	locations.text = ""
	for location in collected_catchable.areas_found_in:
		locations.text += location.name + ", "
	for period in collected_catchable.periods:
		var icon = day_night_icon_scene.instantiate()
		periods_container.add_child(icon)
		icon.init(period)
