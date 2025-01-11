extends StateMachineState


@onready var controller = get_parent()

@export var MIN_SPEED = 3
@export var MAX_SPEED = 10
@export var MAX_ELAPSED = 2
@export var ZOOM_FACTOR = 5
var speed :float = 0
var elapsed :float = 0


# Called when the state machine enters this state.
func on_enter():
	print("fire state")
	elapsed = 0
	controller.remove_rope()


func spawn_bobber():
	var hook = controller.bobber_scene.instantiate()
	controller.bobber = hook
	get_tree().root.add_child(hook)
	
	if controller.raycast.is_colliding():
		controller.hook_spawner.look_at(controller.raycast.get_collision_point())
	else:
		controller.hook_spawner.rotation = Vector3.ZERO
	
	hook.global_position = controller.hook_spawner.global_position
	hook.global_rotation = controller.hook_spawner.global_rotation
	hook.linear_velocity = controller.velocity
	hook.apply_impulse(-hook.transform.basis.z * speed)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if elapsed < MAX_ELAPSED:
		elapsed += delta
		controller.zoom_progressive_camera(-elapsed * ZOOM_FACTOR)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if Input.is_action_just_released("shoot"):
		speed = elapsed * (MAX_SPEED - MIN_SPEED) + MIN_SPEED
		spawn_bobber()
		controller.fishing_sm.set_current_state(controller.throw_fishing_state)


# Called when the state machine exits this state.
func on_exit():
	controller.reset_zoom_camera()
	pass
