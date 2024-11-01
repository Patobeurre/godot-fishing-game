extends Node3D


@onready var camera = $SubViewport/Camera3D
@onready var animation_player = $AnimationPlayer
@onready var trigger_area = $Area3D
@onready var sun_mesh = $Sun
@onready var sun_light = $Sun/OmniLight3D
@onready var sun_particules = $Sun/GPUParticles3D2
@onready var raycast :RayCast3D = $RayCast3D

var sun_spawn_pos :Vector3
var sun_position :Vector3 = Vector3.ZERO
var is_sun_in_position :bool = false
var is_sun_displayed :bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.global_position = $CameraPosition.global_position
	camera.global_rotation = $CameraPosition.global_rotation
	sun_spawn_pos = $SunSpawnPosition.global_position
	animation_player.stop()
	sun_mesh.visible = false
	enable_trigger_area(is_sun_in_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sun_light.omni_range = sun_mesh.scale.x * 16
	is_sun_in_position = raycast.is_colliding()
	
	if raycast.is_colliding():
		is_sun_in_position = true
		sun_position = raycast.get_collider().global_position
	
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
			
	#animation_player.play("sun_disappear")
	
	sun_particules.emitting = false
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(sun_mesh, "global_position", sun_position, 1)
	tween.parallel().tween_property(sun_mesh, "scale", Vector3(0.1, 0.1, 0.1), 1)
	tween.play()
	
	is_sun_displayed = false
	
	await tween.finished
	
	SignalBus.hide_sun.emit(false)	
	sun_mesh.visible = false


func make_sun_appear():
	SignalBus.hide_sun.emit(true)
	
	sun_mesh.global_position = sun_position
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(sun_mesh, "global_position", sun_spawn_pos, 1)
	tween.parallel().tween_property(sun_mesh, "scale", Vector3(1.1, 1.1, 1.1), 1)
	sun_mesh.visible = true
	tween.play()
	
	is_sun_displayed = true
	
	await tween.finished
	
	sun_particules.emitting = true
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not is_sun_in_position: return
	make_sun_appear()

func _on_area_3d_body_exited(body: Node3D) -> void:
	make_sun_disappear()
