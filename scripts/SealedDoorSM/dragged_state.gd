extends StateMachineState


var controller


# Called when the state machine enters this state.
func on_enter() -> void:
	print("dragged state")
	controller = get_parent()


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	if not Input.is_action_pressed("mouse_left"):
		controller.stop_dragging()


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		controller.drag_to_new_rotation()


# Called when the state machine exits this state.
func on_exit() -> void:
	controller.end_rotation()
