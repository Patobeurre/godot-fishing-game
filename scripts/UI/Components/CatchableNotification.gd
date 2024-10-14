extends Panel


@export var anim_speed :float = 2.0

@onready var stary_background :Sprite2D = $MarginContainer/HBoxContainer/PanelContainer/StaryBackground
@onready var image_container = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/Image
@onready var label :RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var catchable :CatchableRes


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stary_background.rotation += anim_speed * delta


func set_catchable(newCatchable :CatchableRes):
	catchable = newCatchable
	update()

func update():
	image_container.texture = catchable.image
	label.text = "[b][i]" + catchable.name + "[/i][/b]"
