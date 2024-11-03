extends CharacterBody3D
class_name Character


@export_subgroup("Properties")
@export var movement_speed = 5
@export var jump_strength = 8
@export var dash_speed = 30
@export var zoom_value = 10

@export var STEP_HEIGHT: float = 0.2

@export var push_force :float = 80.0

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

var tween:Tween

signal health_updated

@onready var body = $Body
@onready var foot = $Body/Foot
@onready var camera = $Body/Head/Camera
@onready var raycast = $Body/Head/Camera/RayCast
@onready var hook_spawner = $Body/Head/Camera/HookSpawner
@onready var sound_footsteps = $SoundFootsteps
@onready var dash_cooldown = $DashCD
@onready var dash_duration = $DashDuration

@onready var raycast_stairs = $StairSystem
@onready var raycast_stairs_fwd: RayCast3D = $StairSystem/RayCastFwd
@onready var raycast_stairs_down: RayCast3D = $StairSystem/RayCastDown
@onready var hit_debug = preload("res://sprites/hit_debug.tscn")

@onready var raycast_interact :RayCast3D = $Body/Head/Camera/RayCastInteract
@onready var label_interact :RichTextLabel = $InteractUI/CenterContainer/MarginContainer/TextInteract

@onready var raycast_footstep :RayCast3D = $Body/Foot/RayCastFootstep
var footstep_sounds_path :String = ""

@onready var bobber_scene = preload("res://objects/bobber.tscn")
var bobber = null

@onready var fishing_sm: FiniteStateMachine = $FishingStateMachine
@onready var default_fishing_state: StateMachineState = $DefaultFishingState
@onready var fire_fishing_state: StateMachineState = $FireFishingState
@onready var throw_fishing_state: StateMachineState = $ThrowFishingState
@onready var retreive_fishing_state: StateMachineState = $RetreiveFishingState
@onready var waiting_fishing_state: StateMachineState = $WaitingFishingState
@onready var catch_fishing_state: StateMachineState = $CatchFishingState
@onready var play_fishing_state: StateMachineState = $PlayingFishingState
@onready var area_info_fishing_state: StateMachineState = $AreaInfoFishingState
@onready var in_interaction_state: StateMachineState = $InteractionState

@onready var safe_position_timer :Timer = $SafePositionTimer
var safe_position :Vector3 = Vector3.ZERO

var character_stats :CharacterStats

@onready var area_info_ui :AreaInfoUI = $AreaInfoUI
@onready var hud := $HUD


var is_jumping :bool = false
var is_in_air :bool = false
var is_dashing :bool = false
var is_dash_enabled :bool = true
var is_climbing_step :bool = false
var is_interacting :bool = false

var is_movement_enabled :bool = true
var is_camera_enabled :bool = true
var is_fishing_enabled :bool = true


func _instantiate_hit_debug(point: Vector3):
	var rd = hit_debug.instantiate()
	var world = get_tree().get_root()
	world.add_child(rd)
	rd.global_translate(point)

class StepResult:
	var diff_position: Vector3 = Vector3.ZERO
	var normal: Vector3 = Vector3.ZERO
	var is_step_up: bool = false

func step_check(delta: float, is_jumping_: bool, step_result: StepResult):
	return false
	if direction != Vector3.ZERO:
		raycast_stairs.look_at(foot.global_position + direction, Vector3.UP)
	
	if direction != Vector3.ZERO and raycast_stairs_fwd.is_colliding():
		if direction.dot(raycast_stairs_fwd.get_collision_normal()) > 0:
			return false
		
		var point_fwd = raycast_stairs_fwd.get_collision_point()
		
		if raycast_stairs_down.is_colliding():
			var point_down = raycast_stairs_down.get_collision_point()
			_instantiate_hit_debug(point_down)
			if point_down.y - point_fwd.y < STEP_HEIGHT:
				step_result.is_step_up = true
				step_result.diff_position = Vector3(point_fwd.x, point_down.y, point_fwd.z)
				return true
	
	return false


func _climb_step(to :Vector3, duration :float = 0.05):
	is_climbing_step = true
	to.y += global_position.y - foot.global_position.y
	
	
	var pos_intermediate :Vector3 = self.global_position
	pos_intermediate.y = to.y
	
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", pos_intermediate, duration)
	tween.play()
	
	await tween.finished
	
	print("UP finished")
	
	
	tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", to, duration)
	tween.play()
	
	await tween.finished
	
	print("FWD finished")
	
	is_climbing_step = false


func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	safe_position = global_position
	rotation_target = camera.global_rotation
	
	fishing_sm.set_current_state(default_fishing_state)
	fishing_sm.is_input_disabled = true
	
	ProgressVariables.progress_variable_updated.connect(on_update_progress_variable)
	
	SignalBus.enable_player_camera.connect(enable_camera_controls)
	SignalBus.enable_player_movements.connect(enable_movements_controls)
	SignalBus.enable_player_fishing.connect(enable_fishing_controls)
	SignalBus.enable_player_hud.connect(enable_hud)
	
	SignalBus.interact_request.connect(_on_interact_requested)
	SignalBus.end_camera_interaction.connect(_on_end_camera_interaction)
	CameraTransition.end_camera_transition.connect(_on_end_camera_transition)
	
	SignalBus.bobber_enter_fishing_area.connect(_on_bobber_enter_fishing_area)
	SignalBus.bobber_collide_wall.connect(_on_bobber_collide_wall)
	SignalBus.bobber_return_to_player.connect(retreive_fishing_state.destroy_bobber)
	SignalBus.catching_finished.connect(play_fishing_state.end_playing)
	SignalBus.minigame_score_updated.connect(play_fishing_state.on_minigame_score_updated)
	SignalBus.cancel_fishing.connect(on_cancel_fishing)
	SignalBus.start_minigame.connect(on_minigame_started)


func _physics_process(delta):
	
	if movement_velocity != Vector3.ZERO:
		SignalBus.player_pos_update.emit(global_position)
	
	# Handle functions
	
	if is_on_floor():
		is_jumping = false
		is_in_air = false
		if safe_position_timer.is_stopped():
			safe_position_timer.start()
	else:
		is_in_air = true
		safe_position_timer.stop()
	
	handle_controls(delta)
	
	if default_fishing_state.is_current_state() and \
		not UiManager.is_menu_opened:
		handle_interaction()
	
	if not is_climbing_step:
		
		# Movement
		
		if is_dashing:
			movement_velocity = movement_velocity.lerp(dash_speed * direction_dash, delta * 10)
		else:
			handle_gravity(delta)
			movement_velocity = movement_velocity.lerp(movement_speed * direction, delta * 10)
			movement_velocity.y = -gravity
		
		var step_result : StepResult = StepResult.new()
		var is_step : bool = step_check(delta, is_jumping, step_result)
		
		if is_step:
			_climb_step(step_result.diff_position)
		
		set_velocity(movement_velocity)
		set_max_slides(6)
		move_and_slide()
	
	# Push RigidBody3D
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	
	# Rotation Camera
	
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 6 * delta, delta * 5)	
	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)

	if bobber != null:
		if global_position.distance_to(bobber.global_position) > 1:
			var bobber_pos = bobber.global_position
			bobber_pos.y = global_position.y
			look_at(bobber_pos, Vector3.UP)
			camera.look_at(bobber.global_position, Vector3.UP)
	
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
	
	# Falling/respawning
	
	if position.y < -0.5:
		global_position = safe_position
	
	if is_jumping:
		is_jumping = false
		is_in_air = true


func _on_bobber_enter_fishing_area(area: CatchableArea):
	if not throw_fishing_state.is_current_state():
		return
	
	if FishingManager.get_current_lure().tags.has(CatchableRes.ELureTag.BOOKWORM):
		fishing_sm.set_current_state(area_info_fishing_state)
	else:
		fishing_sm.set_current_state(waiting_fishing_state)


func _on_bobber_collide_wall():
	fishing_sm.set_current_state(retreive_fishing_state)


func on_minigame_started():
	fishing_sm.set_current_state(play_fishing_state)


func on_cancel_fishing():
	if not default_fishing_state.is_current_state():
		fishing_sm.set_current_state(retreive_fishing_state)
		print("cancel fishing")


func show_fishing_area_info_ui(to_show :bool):
	if to_show:
		area_info_ui.activate(FishingManager.current_catchable_area.get_fish_table())
	else:
		area_info_ui.deactivate()


# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and is_camera_enabled:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity
	
	handle_menu_inputs(event)


func handle_menu_inputs(_event):
	if not is_movement_enabled: return
	
	if Input.is_action_just_pressed("open_collection_menu"):
		UiManager.open("FishCollection")
	
	if default_fishing_state.is_current_state():
		if Input.is_action_just_pressed("mouse_right"):
			UiManager.open("LureCollection")
	
	if default_fishing_state.is_current_state():
		if ProgressVariables.check_variable("identification_book_obtained", false):
			return
		if Input.is_action_just_pressed("open_identification_book"):
			UiManager.open("IdentificationBook")


func handle_interaction():
	var coll = raycast_interact.get_collider()
	
	if raycast_interact.is_colliding() and \
		coll.is_in_group("Interactable"):
		
		is_interacting = true
		enable_fishing_controls(false)
		hud.enable_crosshair(false)
		label_interact.text = coll.interact_text
		$InteractUI.show()
		if Input.is_action_just_pressed("interact"):
			coll.interact()
	else:
		if is_interacting:
			is_interacting = false
			$InteractUI.hide()
			enable_fishing_controls(true)
			hud.enable_crosshair(true)


func enable_hud(enabled :bool):
	if enabled:
		hud.show()
	else:
		hud.hide()
		$InteractUI.hide()


func handle_controls(_delta):
	
	if not is_movement_enabled:
		return
	
	# Mouse capture
	
	if Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		is_camera_enabled = true
	
	if Input.is_action_just_pressed("mouse_capture_exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		is_camera_enabled = false
		
		input_mouse = Vector2.ZERO
	
	# Movement
	
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (body.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	#movement_velocity = Vector3(input.x, 0, input.y).normalized() * movement_speed
	
	#action_zoom()
	
	action_dash()
	
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


# Zooming

func action_zoom():
	if Input.is_action_just_pressed("zoom"):
		CameraTransition.zoom_camera(camera, camera.fov - zoom_value, 1)

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


var INITIAL_FOV = 75

func zoom_camera(value :float, duration :float = 1.0):
	var tween = get_tree().create_tween().bind_node(camera).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "fov", value, duration)
	tween.play()
	
	await tween.finished

func reset_zoom_camera():
	zoom_camera(INITIAL_FOV)


func enable_movements_controls(enabled :bool):
	is_movement_enabled = enabled
	direction = Vector3.ZERO
	movement_velocity = Vector3.ZERO

func enable_camera_controls(enabled :bool):
	is_camera_enabled = enabled

func enable_fishing_controls(enabled :bool):
	if ProgressVariables.check_variable("fishing_gear_obtained", false):
		return
	fishing_sm.is_input_disabled = not enabled


func _on_dash_cd_timeout():
	is_dash_enabled = true


func _on_dash_duration_timeout():
	is_dashing = false


func _on_interact_requested(target_camera :Camera3D):
	if CameraTransition.is_transitioning:
		return
	fishing_sm.set_current_state(in_interaction_state)
	enable_player(false)
	CameraTransition.transition_camera(camera, target_camera)


func _on_end_camera_interaction():
	if CameraTransition.is_transitioning:
		return
	CameraTransition.transition_camera(get_viewport().get_camera_3d(), camera)
	fishing_sm.set_current_state(default_fishing_state)


func _on_end_camera_transition():
	if in_interaction_state.is_current_state():
		return
	enable_player(true)


func enable_player(enabled :bool) -> void:
	enable_fishing_controls(enabled)
	enable_movements_controls(enabled)
	enable_camera_controls(enabled)
	enable_hud(enabled)


func on_update_progress_variable(name :String):
	if ProgressVariables.check_variable("fishing_gear_obtained", true):
		enable_fishing_controls(true)


func _on_safe_position_timer_timeout() -> void:
	safe_position = global_position
	character_stats.position = safe_position
	character_stats.rotation = global_rotation
	SignalBus.save_requested.emit()


func set_stats(stats :CharacterStats) -> void:
	character_stats = stats
	safe_position = character_stats.position
	global_position = character_stats.position
	global_rotation = character_stats.rotation
	rotation_target = character_stats.rotation
