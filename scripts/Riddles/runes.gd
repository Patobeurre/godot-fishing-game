extends StaticBody3D


@export var axis :Vector3 = Vector3.FORWARD
@export var angle :float = 180
@export var group_name = "Rune"
@export var is_up :bool = false
@export var matching_value :int = 0


func _ready() -> void:
	self.add_to_group(group_name)


func perform_rotation():
	get_parent().global_rotate(axis, deg_to_rad(angle))
