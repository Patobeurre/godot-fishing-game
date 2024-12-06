extends Resource
class_name CollectedCatchableList


var list :Array[CollectedCatchable] = []


func filter_by_category(category :CategoryRes.ELureCategory) -> CollectedCatchableList:
	list = list.filter(func (item): return item.catchable.category.tag == category)
	return self


func filter_by_period(period :TimePeriod.ETimePeriod) -> CollectedCatchableList:
	list = list.filter(func (item): return item.catchable.periods.has(period))
	return self


func filter_by_tags(tag :CatchableRes.ELureTag) -> CollectedCatchableList:
	list = list.filter(func (item): return item.catchable.tags.has(tag))
	return self


func filter_by_regions(regions :Array[RegionRes]) -> CollectedCatchableList:
	if regions == null:
		return self
	if regions.is_empty():
		return self
	list = list.filter(func (item): return item.catchable.regions.any(
		func (r): return regions.has(r)))
	return self


func filter_by_rarity(rarity :int, permissive :bool) -> CollectedCatchableList:
	if list.is_empty():
		return self
	
	var tmp_list = list.filter(func (item):
		return item.catchable.rarity == rarity)
	
	if tmp_list.is_empty():
		tmp_list = list.filter(func (item):
			return item.catchable.rarity > rarity)
	
	if not tmp_list.is_empty() or not permissive:
		list = tmp_list
		return self
	
	list.sort_custom(func (a, b):
		return a.catchable.rarity > b.catchable.rarity)
	var worse_rarity = list[0].catchable.rarity
	
	list = list.filter(func (item): return item.catchable.rarity == worse_rarity)
	return self


func filter_by_lure(lure :CatchableRes) -> CollectedCatchableList:
	list = list.filter(func (item):
		return item.catchable.lures.has(lure) or \
			lure.tags.any(func (tag) : 
				return item.catchable.lure_tags.has(tag)))
	return self


func is_empty() -> bool:
	return list.is_empty()

func pick_random() -> CollectedCatchable:
	return list.pick_random()


static func create(catchables :Array[CollectedCatchable]) -> CollectedCatchableList:
	var catchable_list = CollectedCatchableList.new()
	catchable_list.list = catchables.duplicate()
	return catchable_list
