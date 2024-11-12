extends StaticBody3D


@export var custom_modifier :float = 1
@export var clamp_angle :float = 10

var parent_node
var initial_rotation :Vector3


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
	parent_node.rotation.x = initial_rotation.x + angle * custom_modifier
