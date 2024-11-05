extends Resource
class_name CollectedCatchable


@export var catchable :CatchableRes
@export var lure_used :Array[CatchableRes] = []
@export var areas_found_in :Array[FishingAreaRes] = []
@export var periods :Array[TimePeriod.ETimePeriod]
@export var amount :int = 1


static func create(new_catchable :CatchableRes) -> CollectedCatchable:
	var collected_catchable = CollectedCatchable.new()
	collected_catchable.catchable = new_catchable
	return collected_catchable


func merge(other :CollectedCatchable) -> CollectedCatchable:
	var new_lure_used = other.lure_used.filter(func (elem): 
		return not lure_used.has(elem))
	lure_used.append_array(new_lure_used)
	
	var new_areas = other.areas_found_in.filter(func (elem): 
		return not areas_found_in.has(elem))
	areas_found_in.append_array(new_areas)
	
	var new_periods = other.periods.filter(func (elem): 
		return not periods.has(elem))
	periods.append_array(new_periods)
	
	amount += other.amount
	
	return self


func update(lure :CatchableRes, area :FishingAreaRes, period :TimePeriod.ETimePeriod):
	update_lures(lure)
	update_areas(area)
	update_periods(period)


func update_lures(lure :CatchableRes):
	if lure == null: return
	if not lure_used.has(lure):
		lure_used.append(lure)
	
func update_areas(area :FishingAreaRes):
	if not areas_found_in.has(area):
		areas_found_in.append(area)

func update_periods(period :TimePeriod.ETimePeriod):
	if not periods.has(period):
		periods.append(period)
