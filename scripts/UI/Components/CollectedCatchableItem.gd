extends Node
class_name CollectedItem


@onready var image :TextureRect = $MarginContainer/HBoxContainer/PanelContainer/TextureRect
@onready var name_label :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/NameLabel
@onready var description :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel
@onready var rarity :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/RarityLabel
@onready var lures :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/RichTextLabel2
@onready var locations :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/RichTextLabel2
@onready var periods_container = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/HBoxContainer
@onready var click_panel = $PanelClick

@onready var day_night_icon_scene = preload("res://objects/UI/DayNightIcon.tscn")

var collected_catchable :CollectedCatchable

signal clicked(CollectedCatchable)


func init(catchable :CollectedCatchable):
	collected_catchable = catchable
	update()


func init_shadow(catchable :CatchableRes):
	collected_catchable = CollectedCatchable.create(catchable)
	update_shadow()


func update():
	image.texture = collected_catchable.catchable.image
	name_label.text = tr(collected_catchable.catchable.name)
	description.text = tr(collected_catchable.catchable.description)
	rarity.text = tr(Rarity.to_text(collected_catchable.catchable.rarity))
	lures.text = ""
	for lure in collected_catchable.lure_used:
		lures.text += tr(lure.name) + ", "
	locations.text = ""
	for location in collected_catchable.areas_found_in:
		locations.text += tr(location.region.name) + ", "
	for period in collected_catchable.periods:
		var icon = day_night_icon_scene.instantiate()
		periods_container.add_child(icon)
		icon.init(period)


func update_shadow():
	image.texture = collected_catchable.catchable.shadow
	name_label.text = "???"
	description.text = "???"
	rarity.text = ""
	lures.text = ""
	locations.text = ""


func _on_panel_click_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		clicked.emit(collected_catchable)
