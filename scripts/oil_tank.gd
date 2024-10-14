extends RigidBody3D


@export var speed :float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Vector3.FORWARD
	linear_velocity = linear_velocity.lerp(speed * direction, delta * 10)
