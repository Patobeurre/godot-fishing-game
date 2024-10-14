extends StateMachineState


@export var waitingTime: float = 3.0

@onready var controller = get_parent()
@onready var waitingTimer = $"WaitingTimer"

var current_fishing_area :CatchableArea

# Called when the state machine enters this state.
func on_enter():
	print("waiting state")
	start_timer()


func start_timer():
	waitingTime = FishingManager.get_waiting_time()
	var time = waitingTime + (randf() * waitingTime / 2)
	waitingTimer.start(time)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if Input.is_action_just_pressed("shoot"):
		controller.fishing_sm.set_current_state(controller.retreive_fishing_state)


# Called when the state machine exits this state.
func on_exit():
	waitingTimer.stop()


func _on_waiting_timer_timeout():
	if FishingManager.picked_catchable != null:
		controller.fishing_sm.set_current_state(controller.catch_fishing_state)
	else:
		controller.fishing_sm.set_current_state(controller.retreive_fishing_state)
