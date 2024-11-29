extends CharacterBody3D
class_name Character


@export_subgroup("Properties")
@export var movement_speed = 5
@export var jump_strength = 8
@export var dash_speed = 30
@export var zoom_value = 10

@export_subgroup("Weapons")
@export var weapons: Array[Weapon] = []

var weapon: Weapon
var weapon_index := 0

var mouse_sensitivity = 500
var gamepad_sensitivity := 0.075

var movement_velocity: Vector3
var rotation_target: Vector3
var direction: Vector3 = Vector3.ZERO
var direction_dash: Vector3 = Vector3.ZERO

var input_mouse: Vector2

var health:int = 100
var gravity := 0.0

var previously_floored := false

var jump_single := true
var jump_double := true

var container_offset = Vector3(1.2, -1.1, -2.75)

@onready var body = $Body
@onready var foot = $Body/Foot
@onready var camera = $Body/Head/Camera
@onready var raycast = $Body/Head/Camera/RayCast
@onready var hook_spawner = $Body/Head/Camera/HookSpawner
@onready var sound_footsteps = $SoundFootsteps
@onready var dash_cooldown = $DashCD
@onready var dash_duration = $DashDuration
@onready var shoot_cooldown = $ShootCD

@onready var raycast_footstep :RayCast3D = $Body/Foot/RayCastFootstep
var footstep_sounds_path :String = ""


var is_jumping :bool = false
var is_in_air :bool = false
var is_dashing :bool = false
var is_dash_enabled :bool = true

var is_movement_enabled :bool = true
var is_camera_enabled :bool = true


@onready var catchable_projectile_scene = preload("res://objects/Shooter/catchable_projectile.tscn")
@export var catchable :CatchableRes


func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	rotation_target = camera.global_rotation
	
	ProgressVariables.progress_variable_updated.connect(on_update_progress_variable)
	
	SignalBus.enable_player_camera.connect(enable_camera_controls)
	SignalBus.enable_player_movements.connect(enable_movements_controls)


func _physics_process(delta):
	
	if movement_velocity != Vector3.ZERO:
		SignalBus.player_pos_update.emit(global_position)
	
	# Handle functions
	
	if is_on_floor():
		is_jumping = false
		is_in_air = false
	else:
		is_in_air = true
	
	handle_controls(delta)
	
	# Movement
	
	if is_dashing:
		movement_velocity = movement_velocity.lerp(dash_speed * direction_dash, delta * 10)
	else:
		handle_gravity(delta)
		movement_velocity = movement_velocity.lerp(movement_speed * direction, delta * 10)
		movement_velocity.y = -gravity
	
	set_velocity(movement_velocity)
	set_max_slides(6)
	move_and_slide()

	# Rotation Camera
	
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 6 * delta, delta * 5)	
	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	# Movement sound
	
	sound_footsteps.stream_paused = true
	
	if raycast_footstep.is_colliding():
		var coll = raycast_footstep.get_collider()
		#var footstep_sounds = coll.get_meta("footstep_sounds")
		
		#if footstep_sounds != null and \
		#	footstep_sounds != footstep_sounds_path:
		#	footstep_sounds_path = footstep_sounds
		#	sound_footsteps.stream = load(footstep_sounds)
		#	sound_footsteps.playing = true
		#	sound_footsteps.stream.loop = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			sound_footsteps.stream_paused = false
	
	# Landing after jump or falling
	
	camera.position.y = lerp(camera.position.y, 0.0, delta * 5)
	
	if is_on_floor() and gravity > 1 and !previously_floored: # Landed
		Audio.play("sounds/land.ogg")
		camera.position.y = -0.1
	
	previously_floored = is_on_floor()
	
	if is_jumping:
		is_jumping = false
		is_in_air = true


# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and is_camera_enabled:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity
	
	handle_menu_inputs(event)


func handle_menu_inputs(_event):
	pass


func handle_controls(_delta):
	
	if not is_movement_enabled:
		return
	
	# Movement
	
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (body.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	#movement_velocity = Vector3(input.x, 0, input.y).normalized() * movement_speed
	
	#action_zoom()
	
	action_dash()
	
	action_shoot()
	
	# Rotation
	
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	
	rotation_target -= Vector3(-rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * gamepad_sensitivity
	rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		
		if is_on_floor():
			is_jumping = true
			is_in_air = false
		
		if jump_single or jump_double:
			Audio.play("sounds/jump_a.ogg, sounds/jump_b.ogg, sounds/jump_c.ogg")
		
		if jump_double:
			
			gravity = -jump_strength
			jump_double = false
			
		if(jump_single): action_jump()
	

# Handle gravity

func handle_gravity(delta):
	
	gravity += 20 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0


# Shoot

func action_shoot():
	
	if Input.is_action_pressed("shoot"):
		
		if shoot_cooldown.is_stopped():
			
			shoot_cooldown.start(1)
			_spawn_projectile()


func _spawn_projectile():
	if raycast.is_colliding():
		hook_spawner.look_at(raycast.get_collision_point())
	else:
		hook_spawner.rotation = Vector3.ZERO
	
	var projectile = catchable_projectile_scene.instantiate()
	var catchable_scene = catchable.scene.instantiate()
	catchable_scene.rotate_y(deg_to_rad(90))
	projectile.add_child(catchable_scene)
	get_tree().root.add_child(projectile)
	
	projectile.global_position = hook_spawner.global_position
	projectile.global_rotation = hook_spawner.global_rotation
	projectile.apply_impulse(-projectile.transform.basis.z * 2)


# Jumping

func action_jump():
	
	gravity = -jump_strength
	
	jump_single = false;
	jump_double = true;


func action_dash():
	
	if Input.is_action_pressed("dash"):
		
		if not is_dash_enabled:
			return
		
		is_dash_enabled = false
		is_dashing = true
		gravity = 0
		
		if direction != Vector3.ZERO:
			direction_dash = direction
		else:
			direction_dash = (body.global_transform.basis * Vector3.FORWARD).normalized()
		
		dash_duration.start()
		dash_cooldown.start()


func enable_movements_controls(enabled :bool):
	is_movement_enabled = enabled
	direction = Vector3.ZERO
	movement_velocity = Vector3.ZERO

func enable_camera_controls(enabled :bool):
	is_camera_enabled = enabled


func _on_dash_cd_timeout():
	is_dash_enabled = true


func _on_dash_duration_timeout():
	is_dashing = false


func enable_player(enabled :bool) -> void:
	enable_movements_controls(enabled)
	enable_camera_controls(enabled)


func on_update_progress_variable(name :String):
	pass
