extends StateMachineState


const ZOOM_STEP :float = 5
const MAX_ZOOM :float = 15

@onready var controller = get_parent()


# Called when the state machine enters this state.
func on_enter():
	print("playing state")
	#SignalBus.start_minigame.emit(FishingManager.picked_catchable)


# Called every frame when this state is active.
func on_process(delta):
	controller.camera.fov += delta
	controller.draw_rope()


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


func bobber_animation_pop_out():
	var target_pos = controller.bobber.global_position
	target_pos.y += 1
	
	var tween := get_tree().create_tween().bind_node(controller.bobber).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(controller.bobber, "global_position", target_pos, 0.5)
	tween.play()
	
	await tween.finished


func end_playing(succeeded :bool):
	if succeeded:
		await bobber_animation_pop_out()
	
	controller.fishing_sm.set_current_state(controller.retreive_fishing_state)


func on_exit():
	controller.reset_zoom_camera()


func on_minigame_score_updated(score :float):
	var fov_step = -score * MAX_ZOOM / 100
	
	controller.zoom_camera(controller.camera.fov + fov_step, 0.8)
