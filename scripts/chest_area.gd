extends CatchableArea
class_name ChestArea

@export var chest :ChestNode
@export var chest_minigame :CatchableRes


func prepare():
	FishingManager.picked_catchable = chest_minigame


func perform():
	FishingManager.start_mini_game(chest_minigame)


func on_finished(succeeded :bool):
	if succeeded:
		chest.init()
		if is_one_shot:
			disable_collision()


func disable_collision():
	if self_node is Area3D:
		self_node.monitoring = false
		self_node.monitorable = false
