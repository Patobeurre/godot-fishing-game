extends Node3D


var children_scenes :Array


func _ready() -> void:
	children_scenes = get_children()
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	SignalBus.new_lure_registered.connect(place_catchable)


func place_catchable(catchable :CatchableRes):
	for child in children_scenes:
		if child.catchable == catchable:
			_display_catchable(child)
			return


func _display_catchable(node :Node3D):
	for child in children_scenes:
		if child == node:
			child.visible = true
		else:
			child.visible = false


func _on_savegame_loaded() -> void:
	var collected_fishes = FishingManager.get_all_collected_by_category(CategoryRes.ELureCategory.FISH)
	for fishes in collected_fishes:
		place_catchable(fishes.catchable)
