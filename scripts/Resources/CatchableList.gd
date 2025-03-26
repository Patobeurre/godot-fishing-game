extends Resource
class_name CatchableList


var list :Array[CatchableRes] = []


func filter_by_period(period :TimePeriod.ETimePeriod) -> CatchableList:
	list = list.filter(func (item): return item.periods.has(period))
	return self


func filter_by_tags(tag :CatchableRes.ELureTag) -> CatchableList:
	list = list.filter(func (item): return item.tags.has(tag))
	return self


func filter_by_regions(regions :Array[RegionRes]) -> CatchableList:
	if regions == null:
		return self
	list = list.filter(func (item): return item.regions.any(
		func (r): return regions.has(r)))
	return self


func filter_by_rarity(rarity :int, permissive :bool) -> CatchableList:
	if list.is_empty():
		return self
	
	var tmp_list = list.filter(func (item):
		return item.rarity >= rarity)
	
	if not tmp_list.is_empty() or not permissive:
		tmp_list.sort_custom(func (a, b):
			return a.rarity < b.rarity)
		list = tmp_list
		return self
	
	list.sort_custom(func (a, b):
		return a.rarity > b.rarity)
	var worse_rarity = list[0].rarity
	
	list = list.filter(func (item): return item.rarity == worse_rarity)
	return self


func filter_by_lure(lure :CatchableRes) -> CatchableList:
	list = list.filter(func (item):
		return item.lures.has(lure) or \
			lure.tags.any(func (tag) : 
				return item.lure_tags.has(tag)))
	return self


func is_empty() -> bool:
	return list.is_empty()

func pick_random() -> CatchableRes:
	return list.pick_random()

func get_catchables() -> Array[CatchableRes]:
	return list


static func create(catchables :Array[CatchableRes]) -> CatchableList:
	var catchable_list = CatchableList.new()
	catchable_list.list = catchables.duplicate()
	return catchable_list
