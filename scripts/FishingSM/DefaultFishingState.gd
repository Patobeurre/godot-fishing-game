extends StateMachineState


@export var basket_speed :float = 5.0

@onready var controller = get_parent()
var basket = null


func on_enter():
	print("default state")
	FishingManager.reset()


func spawn_basket():
	basket = controller.basket_scene.instantiate()
	get_tree().root.add_child(basket)
	
	if controller.raycast.is_colliding():
		controller.hook_spawner.look_at(controller.raycast.get_collision_point())
	else:
		controller.hook_spawner.rotation = Vector3.ZERO
	
	basket.global_position = controller.hook_spawner.global_position
	basket.global_rotation.y = controller.hook_spawner.global_rotation.y
	basket.linear_velocity = controller.velocity
	basket.apply_impulse(-basket.transform.basis.z * 5)


func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	handle_hotkey_inputs()
	
	if Input.is_action_just_pressed("shoot"):
		controller.fishing_sm.set_current_state(controller.fire_fishing_state)


func handle_hotkey_inputs():
	if Input.is_action_just_pressed("hotkey1"):
		if basket == null:
			spawn_basket()
		else:
			FishingManager.add_lures(basket.pop_all())
			#basket.queue_free()


# Called when the state machine exits this state.
func on_exit():
	pass
