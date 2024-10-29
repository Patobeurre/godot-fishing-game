extends StateMachineState


@export var ORBITING_SPEED :float = 0.2
@export var ORBITING_ANGLE :float  = 10.0

@onready var controller = get_parent()


func on_enter() -> void:
	controller.shark_dorsal.look_at(controller.orbit_center_global.global_position)


func on_process(delta: float) -> void:
	pass


func on_physics_process(delta: float) -> void:
	controller.orbit_center_global.rotate(Vector3(0, 1, 0), deg_to_rad(ORBITING_ANGLE) * ORBITING_SPEED * delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	pass
