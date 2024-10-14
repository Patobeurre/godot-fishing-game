extends Resource
class_name FishingStats


@export var catchables :Array[CollectedCatchable]
@export var current_lure :CatchableRes = preload("res://scripts/Resources/Catchables/Lure.tres")


func _init():
	catchables.append(CollectedCatchable.create(current_lure))


func contains(catchable :CatchableRes) -> bool:
	for c in catchables:
		if c.catchable == catchable:
			return true
	return false
