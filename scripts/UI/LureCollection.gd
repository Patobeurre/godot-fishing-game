extends MainUI


@onready var grid_container :GridContainer = $MarginContainer/VSplitContainer/MarginContainer/GridContainer
@onready var catchable_item_container = preload("res://objects/UI/CatchableItem.tscn")

var selected_lure :CatchableItem = null


func _on_ready():
	pass


func _on_process(delta):
	if not is_preventing_input:
		if Input.is_action_just_pressed("ui_cancel") or \
		Input.is_action_just_pressed("mouse_right"):
			UiManager.close(unique_id)


func _on_input(event):
	if Input.is_action_just_released("mouse_right"):
		is_preventing_input = false
	
	if not is_activated:
		if Input.is_action_just_pressed("mouse_right"):
			is_preventing_input = true


func populate_grid():
	for node in grid_container.get_children():
		grid_container.remove_child(node)
	
	var lure_collection = FishingManager.get_collected_catchables()
	#lure_collection = lure_collection.filter(func (elem):
	#	return elem.tags.has(CatchableRes.ELureTag.FISH))
	
	for lure in lure_collection:
		var item = catchable_item_container.instantiate() as CatchableItem
		item.set_catchable(lure.catchable)
		item.pressed.connect(on_change_selected_lure.bind(item))
		grid_container.add_child(item)
		
		if FishingManager.get_current_lure() == lure.catchable:
			selected_lure = item
			item.set_selected(true)
	


func on_change_selected_lure(item :CatchableItem):
	selected_lure.set_selected(false)
	selected_lure = item
	selected_lure.set_selected(true)
	FishingManager.set_current_lure(selected_lure.catchable)


func _on_activate():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)
	populate_grid()

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)
