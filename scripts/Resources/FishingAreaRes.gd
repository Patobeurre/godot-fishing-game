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

var modifier :FishingAreaModifierRes = FishingAreaModifierRes.new()


func pick_catchable(
		period :TimePeriod.ETimePeriod,
		rarity :int,
		lure :CatchableRes,
		tag :CatchableRes.ELureTag,
		allow_default :bool,
		permissive_rarity :bool):
	
	var list := CatchableList.create(catchables)
	
	if period != null:
		list.filter_by_period(period)
	if lure != null:
		list.filter_by_lure(lure)
	if tag != CatchableRes.ELureTag.NONE:
		list.filter_by_tags(tag)
	if rarity != null:
		list.filter_by_rarity(rarity, permissive_rarity)
	
	if list.is_empty():
		if allow_default:
			return default_catchables.pick_random()
		return null
	
	return list.pick_random()


func get_waiting_time() -> float:
	return waiting_time * modifier.waiting_time_factor


func get_rarity(min :int = 0, max :int = 100) -> int:
	var rng = RandomNumberGenerator.new()
	var randomNumber = rng.randi_range(min, max) * modifier.rarity_factor
	if randomNumber < min:
		randomNumber = min
	return Rarity.get_rarity(randomNumber)
