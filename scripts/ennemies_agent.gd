extends CharacterBody3D


var movement_speed = 2
var acceleration = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var nav : NavigationAgent3D = $NavigationAgent3D

@export var target : Node3D

const ACCELERATION_DEFAULT: float = 7.0
const ACCELERATION_AIR: float = 1.0
const SPEED_DEFAULT: float = 2
const SPEED_ON_STAIRS: float = 1.5

const STAIRS_FEELING_COEFFICIENT: float = 2.5
const WALL_MARGIN: float = 0.001
const STEP_DOWN_MARGIN: float = 0.01
const STEP_HEIGHT_DEFAULT: Vector3 = Vector3(0, 2, 0)
const STEP_HEIGHT_IN_AIR_DEFAULT: Vector3 = Vector3(0, 2, 0)
const STEP_MAX_SLOPE_DEGREE: float = 40.0
const STEP_CHECK_COUNT: int = 2
const SPEED_CLAMP_AFTER_JUMP_COEFFICIENT = 0.4
const SPEED_CLAMP_SLOPE_STEP_UP_COEFFICIENT = 0.4

var direction: Vector3 = Vector3.ZERO
var applied_velocity: Vector3 = Vector3.ZERO
var gravity_direction: Vector3 = Vector3.ZERO
var head_offset: Vector3 = Vector3.ZERO
var step_height_main: Vector3
var step_incremental_check_height: Vector3

class StepResult:
	var diff_position: Vector3 = Vector3.ZERO
	var normal: Vector3 = Vector3.ZERO
	var is_step_up: bool = false

func step_check(delta: float, is_jumping_: bool, step_result: StepResult):
	var is_step: bool = false
	
	step_height_main = STEP_HEIGHT_DEFAULT
	step_incremental_check_height = STEP_HEIGHT_DEFAULT / STEP_CHECK_COUNT
		
	if gravity_direction.y >= 0:
		for i in range(STEP_CHECK_COUNT):
			var test_motion_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
			
			var step_height: Vector3 = step_height_main - i * step_incremental_check_height
			var transform3d: Transform3D = global_transform
			var motion: Vector3 = step_height
			var test_motion_params: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			var is_player_collided: bool = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)

			if is_player_collided and test_motion_result.get_collision_normal().y < 0:
				continue

			transform3d.origin += step_height
			motion = applied_velocity * delta * 2
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
			if not is_player_collided:
				transform3d.origin += motion
				motion = -step_height
				test_motion_params.from = transform3d
				test_motion_params.motion = motion
				
				is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
				
				if is_player_collided:
					if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
						is_step = true
						step_result.is_step_up = true
						step_result.diff_position = -test_motion_result.get_remainder()
						step_result.normal = test_motion_result.get_collision_normal()
						break
			else:
				var wall_collision_normal: Vector3 = test_motion_result.get_collision_normal()
				transform3d.origin += wall_collision_normal * WALL_MARGIN
				motion = (applied_velocity * delta).slide(wall_collision_normal)
				test_motion_params.from = transform3d
				test_motion_params.motion = motion
				
				is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
				
				if not is_player_collided:
					transform3d.origin += motion
					motion = -step_height
					test_motion_params.from = transform3d
					test_motion_params.motion = motion
					
					is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
					
					if is_player_collided:
						if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
							is_step = true
							step_result.is_step_up = true
							step_result.diff_position = -test_motion_result.get_remainder()
							step_result.normal = test_motion_result.get_collision_normal()
							break

	if not is_jumping_ and not is_step and is_on_floor():
		step_result.is_step_up = false
		var test_motion_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
		var transform3d: Transform3D = global_transform
		var motion: Vector3 = applied_velocity * delta
		var test_motion_params: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
		test_motion_params.from = transform3d
		test_motion_params.motion = motion
		test_motion_params.recovery_as_collision = true

		var is_player_collided: bool = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
		if not is_player_collided:
			transform3d.origin += motion
			motion = -step_height_main
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
			if is_player_collided and test_motion_result.get_travel().y < -STEP_DOWN_MARGIN:
				if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
					is_step = true
					step_result.diff_position = test_motion_result.get_travel()
					step_result.normal = test_motion_result.get_collision_normal()
		elif is_zero_approx(test_motion_result.get_collision_normal().y):
			var wall_collision_normal: Vector3 = test_motion_result.get_collision_normal()
			transform3d.origin += wall_collision_normal * WALL_MARGIN
			motion = (applied_velocity * delta).slide(wall_collision_normal)
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
			if not is_player_collided:
				transform3d.origin += motion
				motion = -step_height_main
				test_motion_params.from = transform3d
				test_motion_params.motion = motion
				
				is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
				
				if is_player_collided and test_motion_result.get_travel().y < -STEP_DOWN_MARGIN:
					if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
						is_step = true
						step_result.diff_position = test_motion_result.get_travel()
						step_result.normal = test_motion_result.get_collision_normal()

	return is_step


func _physics_process(delta):
	
	nav.target_position = target.global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	direction.y = 0
	
	applied_velocity = applied_velocity.lerp(direction * movement_speed, acceleration * delta)
	
	var step_result : StepResult = StepResult.new()
	var is_step : bool = step_check(delta, false, step_result)
	
	if is_step:
		var is_enabled_stair_stepping: bool = true
		if step_result.is_step_up:
			if direction.dot(step_result.normal) > 0:
				global_transform.origin += applied_velocity * delta
				applied_velocity *= SPEED_CLAMP_SLOPE_STEP_UP_COEFFICIENT
				gravity_direction *= SPEED_CLAMP_SLOPE_STEP_UP_COEFFICIENT

		if is_enabled_stair_stepping:
			global_transform.origin += step_result.diff_position
			head_offset = step_result.diff_position
			movement_speed = SPEED_ON_STAIRS
	else:
		head_offset = head_offset.lerp(Vector3.ZERO, delta * movement_speed * STAIRS_FEELING_COEFFICIENT)
		
		if abs(head_offset.y) <= 0.01:
			movement_speed = SPEED_DEFAULT
	
	applied_velocity.y = -gravity
	
	set_velocity(applied_velocity)
	set_max_slides(6)
	move_and_slide()
