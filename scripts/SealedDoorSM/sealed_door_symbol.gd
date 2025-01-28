extends StaticBody3D
class_name RotatingSymbol


@export var custom_modifier :float = 1
@export var clamp_angle :float = 10
@export var validation_angle :float = 0
@export var angle_offset :float = 5

@export_group("Boundaries")
@export var min_angle :float = -360
@export var max_angle :float = 360

var parent_node
var initial_rotation :Vector3
var is_completed :bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_node = get_parent()
	initial_rotation = parent_node.global_rotation
	self.add_to_group("Symbol")


func lock_rotation(angle :float):
	angle = snapped(angle, deg_to_rad(clamp_angle))
	apply_rotation(angle)
	initial_rotation = parent_node.rotation


func apply_rotation(angle :float):
	var new_angle = fmod(initial_rotation.x + angle * custom_modifier, deg_to_rad(360))
	if new_angle > deg_to_rad(min_angle) and new_angle < deg_to_rad(max_angle):
		parent_node.rotation.x = new_angle


func set_completed(parent :Node3D):
	parent_node.rotation.x = deg_to_rad(validation_angle)
	parent_node.reparent(parent)


func check_completion() -> bool:
	var current_angle :int = rad_to_deg(parent_node.rotation.x)
	
	if range(validation_angle - angle_offset, validation_angle + angle_offset).has(current_angle):
		is_completed = true
		return true
	
	var opposite_angle = _get_opposite_angle(validation_angle)
	if range(opposite_angle - angle_offset, opposite_angle + angle_offset).has(current_angle):
		is_completed = true
		return true
	
	return false


func _get_opposite_angle(angle :float) -> float:
	if angle < 0:
		return angle + 360
	return angle - 360
