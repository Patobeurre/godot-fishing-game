extends MeshInstance3D


@export var rotation_speed :float = 10


func _ready() -> void:
	rotation_speed = randf()


func _process(delta: float) -> void:
	rotate_y(rotation_speed * delta)
