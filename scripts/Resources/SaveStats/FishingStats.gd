extends Resource
class_name FishingStats


@export var catchables :Array[CollectedCatchable]
@export var identification_list :Array[IdentifiedRes] = []
@export var current_lure :CatchableRes = preload("res://scripts/Resources/Catchables/Lure.tres")
var starter_identification_list = preload("res://scripts/Resources/Identification/IdentificationListStarter.tres")


func _init():
	catchables.append(CollectedCatchable.create(current_lure))
	for item in starter_identification_list.entries:
		identification_list.append(IdentifiedRes.create(item))


func contains(catchable :CatchableRes) -> bool:
	for c in catchables:
		if c.catchable == catchable:
			return true
	return false
