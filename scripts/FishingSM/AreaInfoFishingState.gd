extends StateMachineState


@onready var controller = get_parent()


# Called when the state machine enters this state.
func on_enter():
	print("area info state")
	controller.show_fishing_area_info_ui(true)


# Called every frame when this state is active.
func on_process(delta):
	controller.draw_rope()


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass

# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if Input.is_action_just_pressed("shoot"):
		controller.fishing_sm.set_current_state(controller.retreive_fishing_state)


# Called when the state machine exits this state.
func on_exit():
	controller.show_fishing_area_info_ui(false)
