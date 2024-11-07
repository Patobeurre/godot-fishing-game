extends StateMachineState


@export var basket_speed :float = 5.0

@onready var controller = get_parent()


func on_enter():
	print("default state")
	FishingManager.reset()


func spawn_basket(type :BasketTypeRes.EBasketType):
	var basket_res = BasketManager.pick_available_basket(type)
	if basket_res == null:
		return
	basket_res.set_available(false)
	
	var basket = basket_res.basket_type_res.scene.instantiate()
	get_tree().root.add_child(basket)
	basket.set_res(basket_res)
	
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


func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	handle_hotkey_inputs()
	
	if Input.is_action_just_pressed("shoot"):
		controller.fishing_sm.set_current_state(controller.fire_fishing_state)


func handle_hotkey_inputs():
	if Input.is_action_just_pressed("hotkey1"):
		if BasketManager.has_available_baskets(BasketTypeRes.EBasketType.SIMPLE):
			spawn_basket(BasketTypeRes.EBasketType.SIMPLE)
	if Input.is_action_just_pressed("hotkey2"):
		if BasketManager.has_available_baskets(BasketTypeRes.EBasketType.MEDIUM):
			spawn_basket(BasketTypeRes.EBasketType.MEDIUM)


# Called when the state machine exits this state.
func on_exit():
	pass
