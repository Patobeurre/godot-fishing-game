extends Resource
class_name FishingAreaRes

enum EAreaType {
	NONE,
	WATER,
	
}

@export var name :String
@export var type :EAreaType
@export var waiting_time :float = 3.0
@export var catchables: Array[CatchableRes]
@export var default_catchables: Array[CatchableRes]


func pick_random(period :TimePeriod.ETimePeriod):
	var rng = RandomNumberGenerator.new()
	var randomNumber = rng.randi_range(0, 100)
	var rarity = Rarity.get_rarity(randomNumber)
	
	var available_catchables = catchables.filter(func (catchable):
		return catchable.periods.has(period))
	
	if available_catchables.is_empty():
		available_catchables = default_catchables
	
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
