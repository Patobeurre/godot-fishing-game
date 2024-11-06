extends Button
class_name CatchableItem


@onready var texture_rect :TextureRect = $MarginContainer/TextureRect
@onready var name_label := $MarginContainer2/NameLabel
@onready var amount_label := $MarginContainer/TextureRect/AmountLabel
@onready var background_texture_selected :TextureRect = $TextureRectSelected

var catchable :CollectedCatchable
var is_selected :bool = false


func _ready():
	custom_minimum_size = Vector2(200, 200)
	update()


func set_catchable(lure :CollectedCatchable):
	catchable = lure


func set_selected(selected :bool):
	is_selected = selected
	update()


func update():
	name_label.text = catchable.catchable.name
	texture_rect.texture = catchable.catchable.image
	amount_label.text = "x" + str(catchable.amount)
	disabled = is_selected
	background_texture_selected.visible = is_selected
