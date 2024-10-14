extends StateMachineState


@export var parent :CharacterBody3D

var nav :NavigationAgent3D
var target :CharacterBody3D
var raycast_stairs_fwd :RayCast3D
var raycast_stairs_down :RayCast3D

var direction :Vector3 = Vector3.ZERO
var applied_velocity :Vector3 = Vector3.ZERO
var is_climbing_step :bool = false

@export_group("Movements")
@export var movement_speed :float = 2.0
@export var acceleration :float = 10
@export var gravity :float = 9.8
@export var STEP_HEIGHT: float = 0.2

class StepResult:
	var diff_position: Vector3 = Vector3.ZERO
	var normal: Vector3 = Vector3.ZERO
	var is_step_up: bool = false


func step_check(delta: float, is_jumping_: bool, step_result: StepResult):
	
	if direction != Vector3.ZERO:
		parent.raycast_stairs.look_at(parent.position + direction, Vector3.UP)
		
	if direction != Vector3.ZERO and raycast_stairs_fwd.is_colliding():
		if direction.dot(raycast_stairs_fwd.get_collision_normal()) > 0:
			return false
		
		var point_fwd = raycast_stairs_fwd.get_collision_point()
		
		if raycast_stairs_down.is_colliding():
			var point_down = raycast_stairs_down.get_collision_point()
			if point_down.y - point_fwd.y < STEP_HEIGHT:
				step_result.is_step_up = true
				step_result.diff_position = Vector3(point_fwd.x, point_down.y, point_fwd.z)
				return true
	
	return false

func _climb_step(to :Vector3, duration :float = 0.1):
	is_climbing_step = true
	
	var pos_intermediate :Vector3 = parent.global_position
	pos_intermediate.y = to.y
	
	var tween := get_tree().create_tween().bind_node(parent).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(parent, "global_position", pos_intermediate, duration)
	tween.play()
	await tween.finished
	
	tween = get_tree().create_tween().bind_node(parent).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(parent, "global_position", to, duration)
	tween.play()
	await tween.finished
	
	is_climbing_step = false


# Called when the state machine enters this state.
func on_enter():
	nav = parent.nav
	target = parent.target
	raycast_stairs_fwd = parent.raycast_stairs_fwd
	raycast_stairs_down = parent.raycast_stairs_down
	pass


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	nav.target_position = target.global_position
	
	direction = nav.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	direction.y = 0
	
	var look_direction = target.position
	look_direction.y = parent.position.y
	parent.look_at(look_direction, Vector3.UP, true)
	
	applied_velocity = applied_velocity.lerp(direction * movement_speed, acceleration * delta)
	
	if not is_climbing_step:
		var step_result : StepResult = StepResult.new()
		var is_step : bool = step_check(delta, false, step_result)
		
		if is_step:
			_climb_step(step_result.diff_position)
		
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

