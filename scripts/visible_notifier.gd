extends VisibleOnScreenNotifier3D


@export var node :Node = null


func _ready() -> void:
	if node == null:
		node = get_parent()


func _on_screen_entered() -> void:
	Utilities.enable_mesh_instances(node, true)


func _on_screen_exited() -> void:
	Utilities.enable_mesh_instances(node, false)
