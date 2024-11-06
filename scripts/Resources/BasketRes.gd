extends Resource
class_name BasketRes


@export var max_size :int = 5
@export var frequency :float = 10.0
@export var max_rarity :Rarity.ERarity = Rarity.ERarity.COMMON

@export var catchables :Array[CollectedCatchable] = []
@export var fish_table :FishingAreaRes

@export var position :Vector3 = Vector3.ZERO
@export var rotation :Vector3 = Vector3.ZERO


func pick_catchable(period :TimePeriod.ETimePeriod):
	if get_size() >= max_size:
		return
	
	var rng = RandomNumberGenerator.new()
	var randomNumber = rng.randi_range(max_rarity, 100)
	var rarity = Rarity.get_rarity(randomNumber)
	
	var available_catchables = fish_table.catchables.filter(func (catchable):
		return catchable.periods.has(period))
	
	if available_catchables.is_empty():
		available_catchables = fish_table.default_catchables
	
	if available_catchables.is_empty():
		return null
	
	var available_catchables_rarity = available_catchables.filter(func (catchable):
		return catchable.rarity >= rarity)
	available_catchables_rarity.sort_custom(func (a, b):
		return a.rarity < b.rarity)
	
	if not available_catchables_rarity.is_empty():
		available_catchables = available_catchables_rarity
		var best_rarity_found = available_catchables.front().rarity
		available_catchables = available_catchables.filter(func (catchable):
			return catchable.rarity == best_rarity_found)
		
		if available_catchables.is_empty(): return null
	
	return available_catchables.pick_random()


func add_new_catchable(period :TimePeriod.ETimePeriod):
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
