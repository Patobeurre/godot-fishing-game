extends StateMachineState


@export var DURATION :float = 1.0

@onready var controller = get_parent()



# Called when the state machine enters this state.
func on_enter() -> void:
	var look_at_pos = controller.global_position
	look_at_pos.y = controller.shark_dorsal.global_position.y
	controller.shark_dorsal.look_at(look_at_pos)
	controller.shark_dorsal.rotate_y(deg_to_rad(90))
	
	var tween = get_tree().create_tween().bind_node(controller.shark_dorsal).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(controller.shark_dorsal, "global_position", look_at_pos, 1)
	tween.play()
	
	await tween.finished
	
	controller.state_machine.set_current_state(controller.default_orbiting_state)


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	pass
