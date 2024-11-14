extends CatchableArea
class_name SharkArea


@export var orbit_center_global :Node3D
@export var SPEED_ON_CATCHING :float = 5.0
@export var SPEED_ON_WANDERING :float = 0.2

@onready var shark_dorsal = $RigidBody3D
@onready var orbit_center = $OrbitCenter
@onready var animation_player = $AnimationPlayer

@onready var state_machine :FiniteStateMachine = $FiniteStateMachine
@onready var default_orbiting_state = $DefaultOrbitingState
@onready var catching_state = $CatchingState
@onready var retreive_position_state = $RetreivePositionState

var body_entered :Node3D = null

var is_animated :bool = false
var is_activated :bool = false


func _ready():
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	SignalBus.time_period_changed.connect(_on_time_period_changed)
	animation_player.animation_finished.connect(_on_animation_finished)
	
	state_machine.set_current_state(default_orbiting_state)


func get_fish_table():
	if subFishingAreaEntered != null:
		return subFishingAreaEntered.get_fish_table()
		
	return fishTable


func prepare():
	if subFishingAreaEntered != null:
		subFishingAreaEntered.prepare()
		return
	
	FishingManager.pick_catchable(fishTable)
	state_machine.set_current_state(catching_state)


func _on_animation_finished(name :String):
	is_animated = false


func _shark_sunk():
	var move_to :Vector3 = shark_dorsal.global_position
	move_to.y -= 1
	
	var tween = get_tree().create_tween().bind_node(shark_dorsal).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(shark_dorsal, "global_position", move_to, 0.5)
	tween.play()
	
	await tween.finished


func perform():
	if subFishingAreaEntered != null:
		subFishingAreaEntered.perform()
		return
	
	if FishingManager.picked_catchable != null:
		FishingManager.start_mini_game(FishingManager.picked_catchable)


func on_finished(succeeded :bool):	
	if subFishingAreaEntered != null:
		subFishingAreaEntered.on_finished(succeeded)
		return
	
	if succeeded:
		if is_one_shot:
			_deactivate_area()
		else:
			state_machine.set_current_state(retreive_position_state)
		FishingManager.add_lure(FishingManager.picked_catchable)
		SignalBus.bobber_has_catched.emit(FishingManager.picked_catchable)
	else:
		state_machine.set_current_state(retreive_position_state)


func enable_collision(enabled :bool) -> void:
	if self_node is Area3D:
		self_node.monitoring = enabled
		self_node.monitorable = enabled


func _on_time_period_changed(period :TimePeriod.ETimePeriod):
	for catchable in fishTable.catchables:
		if catchable.periods.has(period):
			_activate_area()
			return
	_deactivate_area()


func _activate_area():
	if is_activated: return
	enable_collision(true)
	shark_dorsal.visible = true
	animation_player.play("emerge")
	is_activated = true


func _deactivate_area():
	state_machine.set_current_state(default_orbiting_state)
	enable_collision(false)
	shark_dorsal.visible = false
	if not is_activated: return
	_shark_sunk()
	is_activated = false


func _on_body_entered(body: Node3D) -> void:
	body_entered = body


func _on_body_exited(body: Node3D) -> void:
	if catching_state.is_current_state():
		state_machine.set_current_state(retreive_position_state)


func _on_savegame_loaded() -> void:
	_on_time_period_changed(TimeManager.get_time_period())
