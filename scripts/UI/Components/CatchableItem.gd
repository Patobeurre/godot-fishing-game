extends Button
class_name CatchableItem


@onready var texture_rect :TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var label :Label = $MarginContainer/VBoxContainer/Label
@onready var background_texture_selected :TextureRect = $TextureRectSelected

var catchable :CatchableRes
var is_selected :bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size = Vector2(200, 200)
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_catchable(lure :CatchableRes):
	catchable = lure

func set_selected(selected :bool):
	is_selected = selected
	update()
	

func update():
	label.text = catchable.name
	texture_rect.texture = catchable.image
	disabled = is_selected
	background_texture_selected.visible = is_selected
