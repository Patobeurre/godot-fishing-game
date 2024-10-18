extends PanelContainer


@onready var container = $MarginContainer/ScrollContainer/VBoxContainer
@onready var fish_entry_scene :PackedScene = preload("res://objects/UI/FishEntry.tscn")

signal item_clicked(CollectedCatchable)


func populate():
	for node in container.get_children():
		node.disconnect("clicked", _on_item_clicked)
		container.remove_child(node)
	
	var collected_fishes = FishingManager.get_all_collected_by_category(CategoryRes.ELureCategory.FISH)
	for catchable in collected_fishes:
		var item = fish_entry_scene.instantiate() as CollectedItem
		container.add_child(item)
		item.init(catchable)
		item.clicked.connect(_on_item_clicked)


func _on_item_clicked(catchable :CollectedCatchable) -> void:
	item_clicked.emit(catchable)
