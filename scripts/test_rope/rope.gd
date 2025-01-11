extends Node3D


@export var begin :Node3D
@export var end :Node3D
@export var path :Path3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.curve.clear_points()
	path.curve.add_point(begin.global_position)
	path.curve.add_point(end.global_position)
