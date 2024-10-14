extends StateMachineState


@onready var controller = get_parent()
@export var speed :float = 20.0

# Called when the state machine enters this state.
func on_enter():
	print("retreive state")
	controller.enable_movements_controls(true)
	controller.bobber.enable_player_area(true)


func retreive_bobber():
	var dir = (controller.global_position - controller.bobber.global_position).normalized()
	controller.bobber.linear_velocity = dir * speed


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if controller.bobber != null:
		retreive_bobber()
	else:
		controller.fishing_sm.set_current_state(controller.default_fishing_state)


func destroy_bobber():
	controller.bobber.queue_free()
	controller.fishing_sm.set_current_state(controller.default_fishing_state)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass
