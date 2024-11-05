extends RigidBody3D


@onready var timer :Timer = $Timer

var catchables :Array[CollectedCatchable] = []

var current_area = null
var is_activated = false


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_activated:
		is_activated = false
		timer.start()


func contains(catchable :CatchableRes) -> bool:
	for c in catchables:
		if c.catchable == catchable:
			return true
	return false


func add_lure(lure :CatchableRes, current_period :TimePeriod.ETimePeriod):
	if contains(lure):
		var collected_lure :CollectedCatchable = catchables.filter(func (elem):
			return elem.catchable == lure)[0]
		collected_lure.update(null, current_area.get_fish_table(), current_period)
		collected_lure.amount += 1
	else:
		var collected_lure = CollectedCatchable.create(lure)
		collected_lure.update(null, current_area.get_fish_table(), current_period)
		catchables.append(collected_lure)


func _on_timer_timeout() -> void:
	var current_period = TimeManager.get_time_period()
	var catchable = current_area.get_fish_table().pick_random(current_period)
	add_lure(catchable, current_period)
	is_activated = true


func pop_all() -> Array[CollectedCatchable]:
	var collected_catchables = catchables.duplicate()
	catchables.clear()
	return collected_catchables

func _on_body_entered(body: Node) -> void:
	linear_velocity = Vector3.ZERO
	gravity_scale = 0
	
	if body.has_method("get_fish_table"):
		current_area = body
		if current_area.get_fish_table().type == FishingAreaRes.EAreaType.WATER:
			is_activated = true
	else:
		queue_free()
