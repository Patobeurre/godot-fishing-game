extends Node3D


@onready var viewport :SubViewport = $SubViewport

var screen_size :Vector2
var viewport_size :Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	viewport_size = viewport.get_visible_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		pass


func _input(ev):
	if ev is InputEventKey:
		if ev.is_pressed():
			var key :String = ev.as_text_keycode()
			
			#if key.length() == 1:
			#	rich_text.add_text(key)
			#if key == "Space":
			#	rich_text.add_text(" ")
