extends StateMachineState


@onready var controller = get_parent()

var anim_duration :float = 1


# Called when the state machine enters this state.
func on_enter() -> void:
	anim_duration = (controller.hand.rotation_degrees - controller.min_rotation) / 360
	anim_duration *= controller.max_anim_duration


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	return
	
	if controller.hand_current_time.rotation_degrees < controller.hand.rotation_degrees:
		controller.hand_current_time.rotation_degrees += anim_duration * delta
		var new_time = fmod((controller.hand_current_time.rotation_degrees) - 90, 360) / 360 * 2400
		TimeManager.set_time_of_day(new_time)
	else:
		controller.state_machine.set_current_state(controller.default_state)


func animate_time_passing():
	var anim_duration = (controller.hand.rotation_degrees - controller.min_rotation) / 360
	anim_duration *= controller.max_anim_duration
	
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(controller.hand_current_time, "rotation_degrees", controller.hand.rotation_degrees, anim_duration)
	tween.play()
	
	await tween.finished
	
	var new_time = fmod((controller.hand.rotation_degrees) - 90, 360) / 360 * 2400
	print(new_time)
	TimeManager.set_time_of_day(new_time)
	UiManager.close(controller.unique_id)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	return
	UiManager.close(controller.unique_id)
