extends CatchableArea

@export var key_catchable :CatchableRes
@export var content_document :DocumentList


func prepare():
	if FishingManager.current_lure == key_catchable:
		FishingManager.picked_catchable = key_catchable
	else:
		FishingManager.cancel()


func perform():
	if FishingManager.current_lure == key_catchable:
		FishingManager.cancel()
		on_finished(true)
		
		Audio.play("sounds/insert_key_chest.ogg")
		SignalBus.update_document_list.emit(content_document)
		
		await get_tree().create_timer(1).timeout
		
		UiManager.open("Documents")
	
	FishingManager.cancel()


func on_finished(succeeded :bool):
	if succeeded:
		if is_one_shot:
			disable_collision()


func disable_collision():
	if self_node is Area3D:
		self_node.monitoring = false
		self_node.monitorable = false
	elif self_node is StaticBody3D:
		$CollisionShape3D.set_deferred("disabled", true)
