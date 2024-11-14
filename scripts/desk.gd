extends Node3D


@onready var desk_body = $Cube_022/StaticBody3D
@onready var drawer_body = $Cube_128/StaticBody3D
@onready var drawer_mesh = $Cube_128
@onready var left_symbol = $Cylinder_014
@onready var right_symbol = $Cylinder_015
@onready var drawer_camera = $Camera3D

@onready var state_machine := $FiniteStateMachine
@onready var inactive_state := $InactiveState
@onready var default_state := $DefaultState
@onready var dragged_state := $DraggedState
@onready var completed_state := $CompletedState

var drawer_pos_offset :float = 0.4
var is_drawer_opened :bool = false
var is_animated :bool = false

var initial_intersection :Dictionary = {}
var current_angle :float = 0.0


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	SignalBus.end_interaction.connect(_set_inactive)
	desk_body.interact_performed.connect(interact_desk)
	drawer_body.interact_performed.connect(interact_drawer)
	_set_inactive()


func start_dragging():
	if completed_state.is_current_state():
		return
	
	initial_intersection = raycast_at_mouse_position(512)
	if initial_intersection.has("collider"):
		if initial_intersection["collider"].is_in_group("Symbol"):
			if not completed_state.is_current_state():
				state_machine.set_current_state(dragged_state)


func stop_dragging():
	if not completed_state.is_current_state():
		state_machine.set_current_state(default_state)


func end_rotation():
	if completed_state.is_current_state():
		return
	
	initial_intersection["collider"].lock_rotation(current_angle)
	if _check_completion():
		state_machine.set_current_state(completed_state)
		on_completed()


func on_completed():
	_place_completed_symbols()
	
	#ProgressVariables.update_progress_variable("drawer_riddle_completed", true)
	SignalBus.end_camera_interaction.emit()
	anim_open_drawer()


func drag_to_new_rotation():
	if completed_state.is_current_state():
		return
	
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
	var mouse_pos = drawer_camera.get_viewport().get_mouse_position()
	var ray_origin = drawer_camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + drawer_camera.project_ray_normal(mouse_pos) * 2000
	var raycast_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	raycast_param.from = ray_origin
	raycast_param.to = ray_end
	raycast_param.collision_mask = mask
	return get_world_3d().direct_space_state.intersect_ray(raycast_param)


func anim_open_drawer():
	if is_animated: return
	
	is_animated = true
	var target_pos :Vector3 = drawer_mesh.position
	
	if is_drawer_opened:
		target_pos.x -= drawer_pos_offset
		drawer_body.interact_text = "Open"
	else:
		target_pos.x += drawer_pos_offset
		drawer_body.interact_text = "Close"
	
	var tween := get_tree().create_tween().bind_node(drawer_mesh).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(drawer_mesh, "position", target_pos, 1)
	tween.play()
	
	await tween.finished
	
	is_drawer_opened = not is_drawer_opened
	is_animated = false


func _check_completion() -> bool:
	var a :int = abs(rad_to_deg(left_symbol.rotation.x))
	var b :int = abs(rad_to_deg(right_symbol.rotation.x))
	print(a)
	print(b)
	
	if a <= 175 or a >= 185:
		return false
	if b <= 175 or b >= 185:
		return false
	
	return true


func _set_inactive():
	if not completed_state.is_current_state():
		state_machine.set_current_state(inactive_state)


func _place_completed_symbols():
	left_symbol.rotation.x = deg_to_rad(180)
	right_symbol.rotation.x = deg_to_rad(180)
	left_symbol.reparent(drawer_mesh)
	right_symbol.reparent(drawer_mesh)


func interact_desk():
	UiManager.open("DocumentsCollection")


func interact_drawer():
	if completed_state.is_current_state():
		anim_open_drawer()
	else:
		SignalBus.interact_request.emit(drawer_camera)
		if not completed_state.is_current_state():
			state_machine.set_current_state(default_state)


func _on_savegame_loaded():
	if ProgressVariables.check_variable("drawer_riddle_completed", true):
		state_machine.set_current_state(completed_state)
		
		_place_completed_symbols()
		
		drawer_body.interact_text = "Open"
