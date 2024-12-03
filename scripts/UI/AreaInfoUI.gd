extends Control
class_name AreaInfoUI


@onready var label = $VBoxContainer/RichTextLabel
@onready var list_container = $VBoxContainer/VBoxContainer
@onready var area_info_entry :PackedScene = preload("res://objects/UI/AreaInfoEntry.tscn")
@onready var unknow_catchable :CatchableRes = preload("res://scripts/Resources/Catchables/Unknown.tres")


func _ready():
	deactivate()


func populate_list(areaRes :FishingAreaRes):
	clear_list()
	
	var lure_collection = FishingManager.get_catchables()
	
	for catchable in areaRes.catchables:
		var entry = area_info_entry.instantiate() as AreaInfoEntry
		list_container.add_child(entry)
		
		if lure_collection.has(catchable):
			entry.init(catchable)
		else:
			entry.init(unknow_catchable)
		


func clear_list():
	for node in list_container.get_children():
		list_container.remove_child(node)


func activate(areaRes :FishingAreaRes):
	populate_list(areaRes)
	label.text = tr(areaRes.region.name)
	visible = true


func deactivate():
	clear_list()
	label.text = ""
	visible = false
