extends Node3D


@export var rotation_speed :float = 5
@export var player :Player

@onready var camera := $Camera3D


func _ready() -> void:
	SignalBus.title_menu_play.connect(_start_playing)
	
	_open_title_menu()


func _open_title_menu() -> void:
	UiManager.open("MainTitle")


func _start_playing() -> void:
	UiManager.close("MainTitle")
	CameraTransition.transition_camera(camera, player.camera, 2.0)


func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed * delta))
