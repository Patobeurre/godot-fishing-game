extends Node

var picked_catchable: CatchableRes = null
var picked_catchable_period = null
var current_catchable_area :CatchableArea = null

var fishing_stats :FishingStats

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
	return current_catchable_area.get_fish_table().waiting_time

func pick_catchable(fishTable: FishingAreaRes):
	print("pick catchable from " + fishTable.name)
	picked_catchable = null
	var current_period = TimeManager.get_time_period()
	
	var rng = RandomNumberGenerator.new()
	var randomNumber = rng.randi_range(0, 100)
	var rarity = Rarity.get_rarity(randomNumber)
	
	print(rarity)
	print(fishTable.catchables)
	
	var available_catchables = fishTable.catchables.filter(func (catchable):
		print(catchable.periods)
		return \
			(catchable.lures.has(fishing_stats.current_lure) or \
			fishing_stats.current_lure.tags.any(func (tag) :
				return catchable.lure_tags.has(tag))) and \
			catchable.periods.has(current_period))
	
	print(available_catchables)
	
	if available_catchables.is_empty():
		available_catchables = fishTable.default_catchables
	
	if available_catchables.is_empty():
		return
	
	var available_catchables_rarity = available_catchables.filter(func (catchable):
		return catchable.rarity >= rarity)
	available_catchables_rarity.sort_custom(func (a, b):
		return a.rarity < b.rarity)
	
	if not available_catchables_rarity.is_empty():
		available_catchables = available_catchables_rarity
		var best_rarity_found = available_catchables.front().rarity
		available_catchables = available_catchables.filter(func (catchable):
			return catchable.rarity == best_rarity_found)
		
		if available_catchables.is_empty(): return
	
	picked_catchable = available_catchables.pick_random()
	picked_catchable_period = current_period
	print(picked_catchable.name)


# Lure Collection

func add_lure(lure :CatchableRes):
	if fishing_stats.contains(lure):
		var collected_lure :CollectedCatchable = fishing_stats.catchables.filter(func (elem):
			return elem.catchable == lure)[0]
		collected_lure.update(fishing_stats.current_lure, current_catchable_area.get_fish_table(), picked_catchable_period)
		collected_lure.amount += 1
	else:
		var collected_lure = CollectedCatchable.create(lure)
		collected_lure.update(fishing_stats.current_lure, current_catchable_area.get_fish_table(), picked_catchable_period)
		fishing_stats.catchables.append(collected_lure)
		SignalBus.new_lure_registered.emit(lure)


func get_collected_catchables() -> Array[CollectedCatchable]:
	return fishing_stats.catchables


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


func set_up_all_lures():
	for catchable in all_lures.catchables:
		for lure_id in catchable.lure_ids:
			catchable.lures.append(get_catchable_by_id(lure_id))

func get_catchable_by_id(id :int):
	var matching_lures = all_lures.catchables.filter(func (catchable):
		return catchable.id == id)
	if not matching_lures.is_empty():
		return matching_lures.front()
