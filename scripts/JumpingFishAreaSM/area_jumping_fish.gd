extends CatchableArea
class_name JumpingFishArea


@export var radius :float = 1.0
@export var scale_offset :float = 0.5
@export var time_offset :float = 0.5

@onready var jumpingfish_scene = preload("res://objects/Catchables/Fishes/jumping_fish.tscn")
@onready var timer :Timer = $Timer


var body_entered :Node3D = null

var is_animated :bool = false
var is_activated :bool = false


func _ready():
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	SignalBus.time_period_changed.connect(_on_time_period_changed)


func get_fish_table():
	if subFishingAreaEntered != null:
		return subFishingAreaEntered.get_fish_table()
		
	return fishTable


func prepare():
	if subFishingAreaEntered != null:
		subFishingAreaEntered.prepare()
		return
	
	FishingManager.pick_catchable(fishTable)


func _on_animation_finished(name :String):
	is_animated = false


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
		#else:
			#state_machine.set_current_state(retreive_position_state)
		FishingManager.add_lure(FishingManager.picked_catchable)
		SignalBus.bobber_has_catched.emit(FishingManager.picked_catchable)
	#else:
		#state_machine.set_current_state(retreive_position_state)


func _get_random_position() -> Vector3:
	var r = radius * sqrt(randf())
	var theta = randf() * 2 * PI
	
	return Vector3(r * cos(theta), 0, r * sin(theta))


func _get_random_scale() -> Vector3:
	var new_scale = randf_range(1 - scale_offset, 1)
	
	return Vector3(new_scale, new_scale, new_scale)


func _get_random_time() -> float:
	var new_time = randf_range(1 - scale_offset, 1)
	
	return new_time


func _spawn_fish():
	var fish = jumpingfish_scene.instantiate()
	add_child(fish)
	fish.visible = false
	fish.position = _get_random_position()
	fish.scale = _get_random_scale()
	fish.play_animation()


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
	#if is_activated: return
	get_parent_node_3d().global_rotation.y = deg_to_rad(randf()*360)
	enable_collision(true)
	timer.start()
	is_activated = true


func _deactivate_area():
	#state_machine.set_current_state(default_orbiting_state)
	enable_collision(false)
	if not is_activated: return
	timer.stop()
	is_activated = false


func _on_body_entered(body: Node3D) -> void:
	body_entered = body
	print("JUMPING AREA")


func _on_body_exited(body: Node3D) -> void:
	#if catching_state.is_current_state():
		#state_machine.set_current_state(retreive_position_state)
	pass


func _on_savegame_loaded() -> void:
	_on_time_period_changed(TimeManager.get_time_period())


func _on_timer_timeout() -> void:
	_spawn_fish()
	timer.start(_get_random_time())
