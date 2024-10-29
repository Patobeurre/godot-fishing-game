extends StateMachineState


@export var ORBITING_SPEED :float = 5.0
@export var ORBITING_ANGLE :float  = 10.0

@onready var controller = get_parent()
@onready var orbit_center = $OrbitCenter


func on_enter() -> void:
	orbit_center.global_position = controller.body_entered.global_position
	controller.shark_dorsal.reparent(orbit_center)
	var look_at_pos = orbit_center.global_position
	look_at_pos.y = controller.shark_dorsal.global_position.y
	controller.shark_dorsal.look_at(look_at_pos)


func on_process(delta: float) -> void:
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	orbit_center.rotate(Vector3(0, 1, 0), deg_to_rad(ORBITING_ANGLE) * ORBITING_SPEED * delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	controller.shark_dorsal.reparent(controller)
