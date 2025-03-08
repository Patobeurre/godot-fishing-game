extends StateMachineState


@onready var timer := $Timer
@onready var controller = get_parent()


# Called when the state machine enters this state.
func on_enter():
	timer.start()


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	controller.look_at_target()


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass


func _on_timer_timeout() -> void:
	controller.state_machine.set_current_state(controller.move_state)
