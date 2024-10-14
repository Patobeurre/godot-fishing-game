extends Node3D


@onready var camera = $SubViewport/Camera3D
@onready var animation_player = $AnimationPlayer
@onready var trigger_area = $Area3D
@onready var sun_mesh = $Sun
@onready var sun_light = $Sun/OmniLight3D
@onready var raycast :RayCast3D = $RayCast3D

var is_sun_in_position :bool = false
var is_sun_displayed :bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.global_position = $CameraPosition.global_position
	camera.global_rotation = $CameraPosition.global_rotation
	animation_player.stop()
	sun_mesh.visible = false
	enable_trigger_area(is_sun_in_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sun_light.omni_range = sun_mesh.scale.x * 16
	is_sun_in_position = raycast.is_colliding()
	enable_trigger_area(is_sun_in_position)
	if is_sun_displayed and not is_sun_in_position:
		make_sun_disappear()


func enable_trigger_area(enabled :bool):
	trigger_area.monitorable = enabled
	trigger_area.monitoring = enabled


func make_sun_disappear():
	if FishingManager.current_catchable_area != null:
		if FishingManager.current_catchable_area.fishTable.name == "Sun":
			FishingManager.cancel()
	animation_player.play("sun_disappear")
	is_sun_displayed = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	print(is_sun_in_position)
	if not is_sun_in_position: return
	animation_player.play("sun_appear")
	is_sun_displayed = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	make_sun_disappear()
