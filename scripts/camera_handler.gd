extends Node


@export var speed : float = 5
@export var angular_acc : float = 10

@onready var player_camera : Camera3D = $Player/Body/Head/Camera
@onready var target_camera : Camera3D = $Terminal_Menu/Camera3D
@onready var hud : CanvasLayer = $HUD

var is_on_player : bool = true
var from : Camera3D
var to : Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if not CameraTransition.is_transitioning:
			_setup_camera_transition()
			CameraTransition.transition_camera(from, to)


func _setup_camera_transition():
	if is_on_player:
		from = player_camera
		to = target_camera
		hud.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	else:
		to = player_camera
		from = target_camera
		hud.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	is_on_player = not is_on_player
