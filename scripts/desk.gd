extends Node3D


@onready var desk_body = $Cube_022/StaticBody3D
@onready var drawer_body = $Cube_128/StaticBody3D
@onready var drawer_mesh = $Cube_128
@onready var drawer_camera = $Camera3D

@onready var state_machine := $FiniteStateMachine
@onready var default_state := $DefaultState
@onready var dragged_state := $DraggedState
@onready var completed_state := $CompletedState

var drawer_pos_offset :float = 0.4
var is_drawer_opened :bool = false
var is_interacting :bool = false

var initial_intersection :Dictionary = {}
var current_angle :float = 0.0


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	desk_body.interact_performed.connect(interact_desk)
	drawer_body.interact_performed.connect(interact_drawer)
	state_machine.set_current_state(default_state)


func start_dragging():
	initial_intersection = raycast_at_mouse_position(512)
	if initial_intersection.has("collider"):
		if initial_intersection["collider"].is_in_group("Symbol"):
			state_machine.set_current_state(dragged_state)


func stop_dragging():
	if _check_completion():
		state_machine.set_current_state(completed_state)
		on_completed()
	else:
		state_machine.set_current_state(default_state)


func on_completed():
	$Cylinder_014.reparent(drawer_mesh)
	$Cylinder_015.reparent(drawer_mesh)
	
	ProgressVariables.update_progress_variable("drawer_riddle_completed", true)
	SignalBus.end_camera_interaction.emit()
	anim_open_drawer()


func end_rotation():
	initial_intersection["collider"].lock_rotation(current_angle)


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
	var mouse_pos = drawer_camera.get_viewport().get_mouse_position()
	var ray_origin = drawer_camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + drawer_camera.project_ray_normal(mouse_pos) * 2000
	var raycast_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	raycast_param.from = ray_origin
	raycast_param.to = ray_end
	raycast_param.collision_mask = mask
	return get_world_3d().direct_space_state.intersect_ray(raycast_param)


func anim_open_drawer():
	if is_interacting: return
	
	is_interacting = true
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
	is_interacting = false


func _check_completion() -> bool:
	var a :int = abs(rad_to_deg($Cylinder_014.rotation.x))
	var b :int = abs(rad_to_deg($Cylinder_015.rotation.x))
	
	if a <= 175 or a >= 185:
		return false
	if b <= 175 or b >= 185:
		return false
	
	return true


func interact_desk():
	UiManager.open("DocumentsCollection")


func interact_drawer():
	if completed_state.is_current_state():
		anim_open_drawer()
	else:
		SignalBus.interact_request.emit(drawer_camera)


func _on_savegame_loaded():
	if ProgressVariables.check_variable("drawer_riddle_completed", true):
		state_machine.set_current_state(completed_state)
		
		$Cylinder_014.rotate_x(deg_to_rad(180))
		$Cylinder_015.rotate_x(deg_to_rad(180))
		$Cylinder_014.reparent(drawer_mesh)
		$Cylinder_015.reparent(drawer_mesh)
		
		drawer_body.interact_text = "Open"
