extends StateMachineState


@export var parent :CharacterBody3D

var target :CharacterBody3D

var gravity = 9.8
var applied_velocity :Vector3 = Vector3.ZERO

# Called when the state machine enters this state.
func on_enter():
	target = parent.target


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	applied_velocity.y = -gravity
	
	parent.set_velocity(applied_velocity)
	parent.set_max_slides(6)
	parent.move_and_slide()


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass

