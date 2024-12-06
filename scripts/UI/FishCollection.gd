extends MainUI


@onready var container = $HSplitContainer/MarginContainer/VSplitContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var filters_container = $HSplitContainer/MarginContainer/VSplitContainer/MarginContainer/VBoxContainer/FlowContainer
@onready var fish_entry_scene :PackedScene = preload("res://objects/UI/FishEntry.tscn")
@onready var category_container = $HSplitContainer/MarginContainer2/Categories
@onready var remaining_fishes_label = $HSplitContainer/MarginContainer/NinePatchRect/RemainingFishesLabel

var category_filter :CategoryRes.ELureCategory = CategoryRes.ELureCategory.FISH
var fish_category :CategoryRes = preload("res://scripts/Resources/Categories/Fishes.tres")

var nb_collected_by_category :int = 0


func _on_ready():
	for child in category_container.get_children():
		child.visible = false
	
	for child :ButtonRegionFilter in filters_container.get_children():
		child.toggled.connect(on_btn_region_filter_clicked)


func _on_process(delta):
	if not is_preventing_input:
		if Input.is_action_just_pressed("ui_cancel") or \
		Input.is_action_just_pressed("open_collection_menu"):
			UiManager.close(unique_id)

func _on_input(event):
	if Input.is_action_just_released("open_collection_menu"):
		is_preventing_input = false
	
	if not is_activated:
		if Input.is_action_just_pressed("open_collection_menu"):
			is_preventing_input = true


func populate():
	for node in container.get_children():
		container.remove_child(node)
	
	var regions_filter :Array[RegionRes] = []
	for child :ButtonRegionFilter in filters_container.get_children():
		if child.button_pressed:
			print(child.get_regions())
		regions_filter.append_array(child.get_regions())
	
	#var catchables_of_category = FishingManager.get_all_collected_by_category(category_filter)
	#nb_collected_by_category = catchables_of_category.size()
	var collected_catchables = \
		CollectedCatchableList.create(FishingManager.fishing_stats.catchables) \
			.filter_by_category(category_filter)
	
	if category_filter == CategoryRes.ELureCategory.FISH:
		collected_catchables = collected_catchables.filter_by_regions(regions_filter)
	
	_update_remaining_catchable()
	
	for catchable in collected_catchables.list:
		var item = fish_entry_scene.instantiate() as CollectedItem
		container.add_child(item)
		item.init(catchable)
	
	filters_container.visible = (category_filter == CategoryRes.ELureCategory.FISH)
	
	if category_filter == CategoryRes.ELureCategory.FISH:
		var remaining_catchables = CatchableList.create(FishingManager.get_all_remaining_fishes()) \
			.filter_by_regions(regions_filter)
		for catchable in remaining_catchables.list:
			var item = fish_entry_scene.instantiate() as CollectedItem
			container.add_child(item)
			item.init_shadow(catchable)


func _update_remaining_catchable():
	remaining_fishes_label.text = str(nb_collected_by_category) \
		+ "/" + str(FishingManager.get_nb_total_catchable_by_category(category_filter))


func update_category_list():
	var categories = FishingManager.get_all_collected_categories()
	
	if categories.is_empty():
		return
	if categories.size() == 1:
		category_filter = categories[0].tag
		return
	
	if not categories.has(fish_category):
		category_filter = categories[0].tag
	
	for category in category_container.get_children():
		category.update(categories)


func _on_activate():
	update_category_list()
	populate()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)


func on_btn_region_filter_clicked(toggled :bool):
	populate()


func _on_btn_fishes_pressed():
	print("fishes")
	category_filter = CategoryRes.ELureCategory.FISH
	populate()


func _on_btn_nature_pressed():
	print("natural")
	category_filter = CategoryRes.ELureCategory.NATURE
	populate()


func _on_btn_insect_pressed():
	print("insects")
	category_filter = CategoryRes.ELureCategory.INSECT
	populate()

func _on_btn_animal_pressed():
	print("animals")
	category_filter = CategoryRes.ELureCategory.ANIMAL
	populate()

func _on_btn_secret_pressed():
	print("items")
	category_filter = CategoryRes.ELureCategory.ITEM
	populate()
