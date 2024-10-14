extends Resource
class_name CollectedCatchable


@export var catchable :CatchableRes
@export var lure_used :Array[CatchableRes] = []
@export var areas_found_in :Array[FishingAreaRes] = []
@export var periods :Array[TimePeriod.ETimePeriod]
@export var amount :int = 0


static func create(new_catchable :CatchableRes) -> CollectedCatchable:
	var collected_catchable = CollectedCatchable.new()
	collected_catchable.catchable = new_catchable
	return collected_catchable


func update(lure :CatchableRes, area :FishingAreaRes, period :TimePeriod.ETimePeriod):
	update_lures(lure)
	update_areas(area)
	update_periods(period)


func update_lures(lure :CatchableRes):
	if not lure_used.has(lure):
		lure_used.append(lure)
	
func update_areas(area :FishingAreaRes):
	if not areas_found_in.has(area):
		areas_found_in.append(area)

func update_periods(period :TimePeriod.ETimePeriod):
	if not periods.has(period):
		periods.append(period)
