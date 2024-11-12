extends Node


const NB_VERIFIED_FOR_VALIDATION :int = 3

var picked_catchable: CatchableRes = null
var picked_catchable_period = null
var current_catchable_area :CatchableArea = null
var verified_list :Array[IdentifiedRes] = []

var fishing_stats :FishingStats

var default_lure :CatchableRes = preload("res://scripts/Resources/Catchables/Lure.tres")
var all_lures :FishingAreaRes = preload("res://scripts/Resources/FishingAreas/all.tres")


func _ready():
	SignalBus.bobber_enter_fishing_area.connect(set_current_catchable_area)
	SignalBus.end_minigame.connect(on_minigame_ended)
	set_up_all_lures()


func set_stats(stats :FishingStats) -> void:
	fishing_stats = stats


func get_current_lure() -> CatchableRes:
	return fishing_stats.current_lure

func set_current_lure(lure :CatchableRes) -> void:
	fishing_stats.current_lure = lure
	SignalBus.save_requested.emit()


func set_current_catchable_area(area :CatchableArea):
	current_catchable_area = area
	current_catchable_area.prepare()

func perform_catch():
	current_catchable_area.perform()


func cancel():
	SignalBus.cancel_fishing.emit()


func reset():
	picked_catchable = null
	current_catchable_area = null


func start_mini_game(catchable :CatchableRes):
	UiManager.open("FishingMiniGame")
	SignalBus.start_minigame.emit()

func on_minigame_ended(succeeded :bool):
	UiManager.close("FishingMiniGame")
	current_catchable_area.on_finished(succeeded)
	SignalBus.catching_finished.emit(succeeded)


func get_waiting_time():
	return current_catchable_area.get_fish_table().get_waiting_time()


func pick_catchable(fishTable: FishingAreaRes):
	print("pick catchable from " + fishTable.name)
	picked_catchable = null
	var current_period = TimeManager.get_time_period()
	var rarity = fishTable.get_rarity()
	
	picked_catchable = fishTable.pick_catchable(
		current_period,
		rarity,
		fishing_stats.current_lure,
		CatchableRes.ELureTag.NONE,
		true, 
		true)
	
	picked_catchable_period = current_period


func verify_identification_list() -> void:
	var unidentified_list := get_identification_list().filter(func (item) : 
		return not item.is_correctly_identified)
	
	verified_list = []
	
	for item :IdentifiedRes in unidentified_list:
		if item.verify():
			verified_list.append(item)
	
	print(verified_list.size())
	if verified_list.size() >= NB_VERIFIED_FOR_VALIDATION:
		for item :IdentifiedRes in verified_list:
			item.is_correctly_identified = true
		SignalBus.validate_identification.emit()
	
	SignalBus.save_requested.emit()


# Lure Collection

func add_lure(lure :CatchableRes):
	if fishing_stats.contains(lure):
		var collected_lure :CollectedCatchable = fishing_stats.catchables.filter(func (elem):
			return elem.catchable == lure)[0]
		collected_lure.update(fishing_stats.current_lure, current_catchable_area.get_fish_table(), picked_catchable_period)
		collected_lure.amount += 1
		SignalBus.lure_added.emit(CollectedCatchable.create(lure))
	else:
		var collected_lure = CollectedCatchable.create(lure)
		collected_lure.update(fishing_stats.current_lure, current_catchable_area.get_fish_table(), picked_catchable_period)
		fishing_stats.catchables.append(collected_lure)
		SignalBus.new_lure_registered.emit(lure)
	#remove_lure(fishing_stats.get_catchable_by_res(fishing_stats.current_lure))


func add_lures(lures :Array[CollectedCatchable]):
	for lure :CollectedCatchable in lures:
		if fishing_stats.contains(lure.catchable):
			var collected_lure :CollectedCatchable = fishing_stats.catchables.filter(func (elem): \
			return elem.catchable == lure.catchable)[0]
			collected_lure.merge(lure)
			SignalBus.lure_added.emit(lure)
		else:
			fishing_stats.catchables.append(lure)
			SignalBus.new_lure_registered.emit(lure.catchable)
		print(lure.catchable.name)


func remove_lure(lure :CollectedCatchable):
	if lure.catchable == default_lure:
		return
	
	var idx = fishing_stats.catchables.find(lure)
	if idx < 0: return
	
	var collected_lure = fishing_stats.catchables[idx]
	if collected_lure.amount > 0:
		collected_lure.amount -= 1
		fishing_stats.update_money(collected_lure.catchable.price)
		if collected_lure.catchable == get_current_lure() and \
			collected_lure.amount < 1:
			set_current_lure(default_lure)
		SignalBus.fish_selled.emit(collected_lure)


func get_collected_catchables() -> Array[CollectedCatchable]:
	return fishing_stats.catchables.filter(func (catchable): return catchable.amount > 0)

func get_catchables() -> Array[CatchableRes]:
	var catchables :Array[CatchableRes] = []
	for collected_catchable in fishing_stats.catchables:
		catchables.append(collected_catchable.catchable)
	return catchables


func get_all_collected_by_category(category : CategoryRes.ELureCategory) -> Array[CollectedCatchable]:
	var collected_lures :Array[CollectedCatchable] = fishing_stats.catchables.filter(func (elem):
		return elem.catchable.category.tag == category)
	
	return collected_lures


func get_all_collected_categories() -> Array[CategoryRes]:
	var categories :Array[CategoryRes] = []
	for catchable in fishing_stats.catchables:
		if catchable.catchable.category.tag != CategoryRes.ELureCategory.NONE and \
			not categories.has(catchable.catchable.category):
			categories.append(catchable.catchable.category)
	return categories


func get_identification_list() -> Array[IdentifiedRes]:
	return fishing_stats.identification_list


func set_up_all_lures():
	for catchable in all_lures.catchables:
		for lure_id in catchable.lure_ids:
			catchable.lures.append(get_catchable_by_id(lure_id))


func get_catchable_by_id(id :int):
	var matching_lures = all_lures.catchables.filter(func (catchable):
		return catchable.id == id)
	if not matching_lures.is_empty():
		return matching_lures.front()
