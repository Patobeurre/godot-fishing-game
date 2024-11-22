extends Node3D


@onready var support_body = $platon_fish_riddle/MainSupport/StaticBody3D
@onready var rotating_panel_node = $platon_fish_riddle/RotatingPanels
@onready var code_panel_mesh = $platon_fish_riddle/RotatingPanels/CodePanel
@onready var camera = $Camera3D

@onready var disk_forest = $platon_fish_riddle/disk_forest/StaticBody3D
@onready var disk_reef = $platon_fish_riddle/disk_reef/StaticBody3D
@onready var disk_beach = $platon_fish_riddle/disk_beach/StaticBody3D

@onready var state_machine := $FiniteStateMachine
@onready var inactive_state := $InactiveState
@onready var default_state := $DefaultState
@onready var dragged_state := $DraggedState
@onready var completed_state := $CompletedState

var panel_pos_offset :float = 0.2
var is_drawer_opened :bool = false
var is_animated :bool = false

var initial_intersection :Dictionary = {}
var initial_mouse_position :Vector2 = Vector2.ZERO
var current_angle :float = 0.0


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	SignalBus.end_interaction.connect(_set_inactive)
	support_body.interact_performed.connect(interact)
	_set_inactive()
	state_machine.set_current_state(default_state)


func start_dragging():
	if completed_state.is_current_state():
		return
	
	initial_intersection = raycast_at_mouse_position(512)
	if initial_intersection.has("collider"):
		if initial_intersection["collider"].is_in_group("Symbol"):
			if not completed_state.is_current_state():
				initial_mouse_position = camera.get_viewport().get_mouse_position()
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
	
	ProgressVariables.update_progress_variable("platon_riddle_completed", true)
	#SignalBus.end_camera_interaction.emit()
	anim_rotate_panel()


func drag_to_new_rotation():
	if completed_state.is_current_state():
		return
	
	var intersection = camera.get_viewport().get_mouse_position()
	
	var p1_y = initial_mouse_position.y
	var p2_y = intersection.y
	
	current_angle = deg_to_rad(p2_y - p1_y)
	initial_intersection["collider"].apply_rotation(current_angle)


func raycast_at_mouse_position(mask :int = 255):
	var mouse_pos = camera.get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var raycast_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	raycast_param.from = ray_origin
	raycast_param.to = ray_end
	raycast_param.collision_mask = mask
	return get_world_3d().direct_space_state.intersect_ray(raycast_param)


func anim_rotate_panel():
	if is_animated: return
	
	is_animated = true
	
	var initial_pos :Vector3 = rotating_panel_node.position
	var target_pos :Vector3 = initial_pos
	target_pos.x -= panel_pos_offset
	
	var tween := get_tree().create_tween().bind_node(rotating_panel_node).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(rotating_panel_node, "position", target_pos, 1)
	tween.play()
	
	await tween.finished
	
	tween = get_tree().create_tween().bind_node(rotating_panel_node).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(rotating_panel_node, "rotation", Vector3(0,0,deg_to_rad(180)), 1)
	tween.play()
	
	await tween.finished
	
	tween = get_tree().create_tween().bind_node(rotating_panel_node).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(rotating_panel_node, "position", initial_pos, 1)
	tween.play()
	
	await tween.finished
	
	is_animated = false


func _check_completion() -> bool:
	return disk_forest.check_completion() and \
		disk_reef.check_completion() and \
		disk_beach.check_completion()


func _set_inactive():
	if not completed_state.is_current_state():
		state_machine.set_current_state(inactive_state)


func _place_completed_symbols():
	disk_forest.set_completed(code_panel_mesh)
	disk_reef.set_completed(code_panel_mesh)
	disk_beach.set_completed(code_panel_mesh)
	
	support_body.set_enabled(false)


func interact():
	SignalBus.interact_request.emit(camera)
	if not completed_state.is_current_state():
		state_machine.set_current_state(default_state)


func _on_savegame_loaded():
	if ProgressVariables.check_variable("platon_riddle_completed", true):
		state_machine.set_current_state(completed_state)
		
		_place_completed_symbols()
		rotating_panel_node.rotation.z = deg_to_rad(180)
