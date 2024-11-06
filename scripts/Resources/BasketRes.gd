extends Resource
class_name BasketRes


@export var max_size :int = 5
@export var time_interval :float = 10.0
@export var min_rarity :Rarity.ERarity = Rarity.ERarity.COMMON

@export var catchables :Array[CollectedCatchable] = []
@export var fish_table :FishingAreaRes

@export var position :Vector3 = Vector3.ZERO
@export var rotation :Vector3 = Vector3.ZERO


func pick_catchable(period :TimePeriod.ETimePeriod):
	if get_size() >= max_size:
		return
	
	var current_period = TimeManager.get_time_period()
	var rarity = fish_table.get_rarity(min_rarity)
	
	return fish_table.pick_catchable(
		current_period,
		rarity,
		null,
		CatchableRes.ELureTag.NONE,
		true,
		false)


func add_new_catchable(period :TimePeriod.ETimePeriod):
	if get_size() >= max_size:
		return
	
	var picked_catchable = pick_catchable(period)
	
	if picked_catchable == null:
		return
	
	if contains(picked_catchable):
		var collected_lure :CollectedCatchable = catchables.filter(func (elem):
			return elem.catchable == picked_catchable)[0]
		collected_lure.update(null, fish_table, period)
		collected_lure.amount += 1
	else:
		var collected_lure = CollectedCatchable.create(picked_catchable)
		collected_lure.update(null, fish_table, period)
		catchables.append(collected_lure)
	
	SignalBus.save_requested.emit()


func get_size() -> int:
	var amount = 0
	for c in catchables:
		amount += c.amount
	return amount


func contains(catchable :CatchableRes) -> bool:
	for c in catchables:
		if c.catchable == catchable:
			return true
	return false
