extends Node3D


@onready var interact_body = $Plane_038/StaticBody3D
@onready var camera = $Camera3D

@onready var blue_flower = $Cylinder_017/StaticBody3D
@onready var green_flower = $Cylinder_016/StaticBody3D
@onready var purple_flower = $Cylinder_018/StaticBody3D

@onready var state_machine := $FiniteStateMachine
@onready var default_state := $DefaultState
@onready var dragged_state := $DraggedState
@onready var completed_state := $CompletedState

var initial_intersection :Dictionary = {}
var current_angle :float = 0.0

@onready var document = preload("res://scripts/Resources/Documents/SunflowerNote.tres")


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	interact_body.interact_performed.connect(_on_interact)


func start_dragging():
	initial_intersection = raycast_at_mouse_position(512)
	if initial_intersection.has("collider"):
		if initial_intersection["collider"].is_in_group("Symbol"):
			state_machine.set_current_state(dragged_state)


func stop_dragging():
	state_machine.set_current_state(default_state)


func on_completed():
	_place_completed_symbols()
	
	ProgressVariables.update_progress_variable("sunflower_riddle_completed", true)
	var documents = DocumentList.create([document])
	MailManager.add_documents_to_inventory(documents)
	SignalBus.show_documents_request.emit(documents)
	SignalBus.end_camera_interaction.emit()


func end_rotation():
	initial_intersection["collider"].lock_rotation(current_angle)
	if _check_completion():
		state_machine.set_current_state(completed_state)
		on_completed()


func drag_to_new_rotation():
	var intersection = raycast_at_mouse_position(1)
	
	var center_3d = initial_intersection["collider"].global_position
	var p1_3d = initial_intersection["position"]
	var p2_3d = intersection["position"]
	
	var center = Vector2(center_3d.y, center_3d.z)
	var p1 = Vector2(p1_3d.y, p1_3d.z)
	var p2 = Vector2(p2_3d.y, p2_3d.z)
	
	current_angle = _get_angle_from_points(center, p1, p2)
	if not _is_dragged_left(center, p1, p2):
		current_angle *= -1
	
	initial_intersection["collider"].apply_rotation(current_angle)



func _get_angle_from_points(p1 :Vector2, p2 :Vector2, p3 :Vector2) -> float:
	var p12 = p1.distance_to(p2)
	var p13 = p1.distance_to(p3)
	var p23 = p2.distance_to(p3)
	
	return acos( (p12*p12 + p13*p13 - p23*p23) / (2*p12*p13) )


func _is_dragged_left(a :Vector2, b :Vector2, c :Vector2) -> bool:
	return (b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x) > 0


func raycast_at_mouse_position(mask :int = 255):
	var mouse_pos = camera.get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var raycast_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	raycast_param.from = ray_origin
	raycast_param.to = ray_end
	raycast_param.collision_mask = mask
	return get_world_3d().direct_space_state.intersect_ray(raycast_param)


func _check_completion() -> bool:	
	return blue_flower.check_completion() and \
		green_flower.check_completion() and \
		purple_flower.check_completion()


func _place_completed_symbols():
	blue_flower.set_completed(self)
	green_flower.set_completed(self)
	purple_flower.set_completed(self)


func _on_interact():
	SignalBus.interact_request.emit(camera)
	state_machine.set_current_state(default_state)


func _on_savegame_loaded():
	return
	if ProgressVariables.check_variable("sunflower_riddle_completed", true):
		pass
