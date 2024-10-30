extends Node3D


@onready var symbol = $Cylinder_010/StaticBody3D
@onready var camera = $Camera3D
@onready var interact_body = $base_door/StaticBody3D

@onready var state_machine = $FiniteStateMachine
@onready var default_state = $DefaultState
@onready var dragged_state = $DraggedState

var initial_intersection :Dictionary = {}
var current_angle :float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact_body.interact_performed.connect(_on_interact_performed)
	state_machine.set_current_state(default_state)


func get_initial_intersection():
	initial_intersection = raycast_at_mouse_position(512)
	if initial_intersection.has("collider"):
		if initial_intersection["collider"].is_in_group("Symbol"):
			state_machine.set_current_state(dragged_state)


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
	var mouse_pos = camera.get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var raycast_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	raycast_param.from = ray_origin
	raycast_param.to = ray_end
	raycast_param.collision_mask = mask
	return get_world_3d().direct_space_state.intersect_ray(raycast_param)


func _on_interact_performed():
	SignalBus.interact_request.emit(camera)
