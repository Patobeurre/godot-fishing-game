extends CatchableArea
class_name ExplodingFishingArea

@export var interaction_catchable :CatchableRes

signal perform_interaction


func get_fish_table():
	if subFishingAreaEntered != null:
		return subFishingAreaEntered.get_fish_table()
	
	if FishingManager.get_current_lure() == interaction_catchable:
		var emptyArea = FishingAreaRes.new()
		emptyArea.waiting_time = 0.01
		return emptyArea
	
	return fishTable


func prepare():
	if subFishingAreaEntered != null:
		subFishingAreaEntered.prepare()
		return
	
	if FishingManager.get_current_lure() == interaction_catchable:
		FishingManager.picked_catchable = interaction_catchable
	else:
		FishingManager.pick_catchable(fishTable)

func perform():
	if subFishingAreaEntered != null:
		subFishingAreaEntered.perform()
		return
	
	if FishingManager.get_current_lure() == interaction_catchable:
		FishingManager.cancel()
		perform_interaction.emit()
	elif FishingManager.picked_catchable != null:
		FishingManager.start_mini_game(FishingManager.picked_catchable)


func on_finished(succeeded :bool):
	if subFishingAreaEntered != null:
		subFishingAreaEntered.on_finished(succeeded)
		return
	
	if succeeded:
		if is_one_shot:
			disable_collision()
		FishingManager.add_lure(FishingManager.picked_catchable)
		SignalBus.bobber_has_catched.emit(FishingManager.picked_catchable)


func disable_collision():
	if self_node is Area3D:
		self_node.monitoring = false
		self_node.monitorable = false
