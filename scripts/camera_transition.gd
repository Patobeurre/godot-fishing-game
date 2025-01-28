extends Node


@onready var camera_tmp : Camera3D = $CameraTmp

var is_transitioning : bool = false
var is_zooming : bool = false

signal end_camera_transition


func transition_camera(from :Camera3D, to :Camera3D, duration :float = 1.0):
	if is_transitioning: return
	
	camera_tmp.global_transform = from.global_transform
	
	is_transitioning = true
	camera_tmp.make_current()
	
	var tween = get_tree().create_tween().bind_node(camera_tmp).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(camera_tmp, "global_transform", to.global_transform, duration)
	tween.parallel().tween_property(camera_tmp, "fov", to.fov, duration)
	tween.play()
	
	await tween.finished
	
	to.make_current()
	is_transitioning = false
	
	end_camera_transition.emit()


func zoom_camera(camera :Camera3D, value :float, duration :float = 1.0):
	if is_zooming: return
	
	camera_tmp.global_transform = camera.global_transform
	
	is_zooming = true
	camera_tmp.make_current()
	
	var tween = get_tree().create_tween().bind_node(camera_tmp).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera_tmp, "fov", camera_tmp.fov + value, duration)
	tween.play()
	
	await tween.finished
	
	is_zooming = false

func cancel_zoom_camera(camera :Camera3D):
	camera_tmp.fov = camera.fov
