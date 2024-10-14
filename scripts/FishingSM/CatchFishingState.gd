extends StateMachineState

@onready var controller = get_parent() 
@onready var timer :Timer = $CatchingTimer


# Called when the state machine enters this state.
func on_enter():
	print("catching state")
	controller.enable_movements_controls(false)
	SignalBus.catching_started.emit()
	timer.start()


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if Input.is_action_just_pressed("shoot"):
		FishingManager.perform_catch()


# Called when the state machine exits this state.
func on_exit():
	timer.stop()


func _on_catching_timer_timeout():
	controller.fishing_sm.set_current_state(controller.retreive_fishing_state)
