extends Node3D


@onready var camera = $Camera3D
@onready var support_body = $StaticBody3D
@onready var support_collision = $StaticBody3D/CollisionShape3D
@onready var radio_node = $radio_desk
@onready var antena_mesh = $radio_desk/antena
@onready var antena_body = $radio_desk/antena/StaticBody3D

@onready var state_machine := $FiniteStateMachine
@onready var default_state := $DefaultState
@onready var dragged_state := $DraggedState

@export var min_angle = -40
@export var max_angle = 60

@export_group("Sounds")
@onready var audio_player_noise := $AudioNoise3D
@export var noise_curve :CurveTexture
@export var frequencies :Array[Frequency]



var initial_intersection :Dictionary = {}
var initial_mouse_position :Vector2 = Vector2.ZERO
var current_angle :float = 0.0


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	SignalBus.new_lure_registered.connect(_on_new_lure_registered)
	support_body.interact_performed.connect(interact)
	antena_body.min_angle = min_angle
	antena_body.max_angle = max_angle
	_update_sound()
	disable_radio()
	state_machine.set_current_state(default_state)


func _process(delta: float) -> void:
	pass


func start_dragging():
	initial_intersection = raycast_at_mouse_position(512)
	if initial_intersection.has("collider"):
		if initial_intersection["collider"].is_in_group("Symbol"):
			initial_mouse_position = camera.get_viewport().get_mouse_position()
			state_machine.set_current_state(dragged_state)

func stop_dragging():
	state_machine.set_current_state(default_state)


func drag_to_new_rotation():
	var intersection = camera.get_viewport().get_mouse_position()
	
	var p1_y = initial_mouse_position.x
	var p2_y = intersection.x
	
	current_angle = deg_to_rad((p2_y - p1_y) * 0.1)
	initial_intersection["collider"].apply_rotation(current_angle)
	
	_update_sound()


func end_rotation():
	initial_intersection["collider"].lock_rotation(current_angle)
	_save()
	_update_sound()


func raycast_at_mouse_position(mask :int = 255):
	var mouse_pos = camera.get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var raycast_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	raycast_param.from = ray_origin
	raycast_param.to = ray_end
	raycast_param.collision_mask = mask
	return get_world_3d().direct_space_state.intersect_ray(raycast_param)


func _update_sound():
	var point = get_normalized_angle(rad_to_deg(antena_mesh.rotation.x))
	audio_player_noise.volume_db = noise_curve.curve.sample(point)
	print(audio_player_noise.volume_db)
	for frequency in frequencies:
		frequency.update_volume(point)


func get_normalized_angle(angle :float) -> float:
	return (angle - min_angle) / (max_angle - min_angle)


func interact():
	SignalBus.interact_request.emit(camera)
	state_machine.set_current_state(default_state)


func disable_radio():
	radio_node.visible = false
	audio_player_noise.stop()
	disable_collision(true)
	for frequency in frequencies:
		frequency.stop()


func enable_radio():
	radio_node.visible = true
	antena_mesh.rotation.x = ProgressVariables.get_value("radio_angle")
	audio_player_noise.play()
	disable_collision(false)
	for frequency in frequencies:
		frequency.play()
	_update_sound()


func disable_collision(enabled :bool):
	support_body.disabled = enabled
	support_collision.disabled = enabled


func _on_new_lure_registered(catchable :CatchableRes):
	if catchable.id == 60: # radio fish ID
		ProgressVariables.update_progress_variable("radio_obtained", true)
		enable_radio()


func _save():
	ProgressVariables.update_progress_variable("radio_angle", antena_mesh.rotation.x)

func _on_savegame_loaded():
	if ProgressVariables.check_variable("radio_obtained", true):
		enable_radio()
