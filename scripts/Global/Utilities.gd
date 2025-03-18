extends Node


func enable_mesh_instances(node :Node, enabled :bool):
	for child in node.find_children("", "MeshInstance3D", true):
		child.visible = enabled
