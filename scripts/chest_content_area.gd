extends CatchableArea

@export var key_catchable :CatchableRes
@export var chest_minigame :CatchableRes
@export var content_document :DocumentList


func prepare():
	FishingManager.picked_catchable = chest_minigame


func perform():
	#if FishingManager.fishing_stats.current_lure == key_catchable:
	#	FishingManager.cancel()
	#	on_finished(true)
	#	
	#	Audio.play("sounds/insert_key_chest.ogg")
	#	SignalBus.update_document_list.emit(content_document)
	#	
	#	await get_tree().create_timer(1).timeout
	#	
	#	#UiManager.open("Documents")
	#	MailManager.add_documents_to_inventory(content_document)
	#	SignalBus.show_documents_request.emit(content_document)
	#FishingManager.cancel()
	
	FishingManager.start_mini_game(chest_minigame)


func on_finished(succeeded :bool):
	if succeeded:
		Audio.play("sounds/insert_key_chest.ogg")
		SignalBus.update_document_list.emit(content_document)
		
		await get_tree().create_timer(1).timeout
		
		#UiManager.open("Documents")
		MailManager.add_documents_to_inventory(content_document)
		SignalBus.show_documents_request.emit(content_document)
		
		if is_one_shot:
			disable_collision()


func disable_collision():
	if self_node is Area3D:
		self_node.monitoring = false
		self_node.monitorable = false
	elif self_node is StaticBody3D:
		$CollisionShape3D.set_deferred("disabled", true)
