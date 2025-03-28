extends StateMachineState


# Called when the state machine enters this state.
func on_enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SignalBus.end_camera_interaction.emit()


# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
