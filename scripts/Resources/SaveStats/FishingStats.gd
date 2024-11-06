extends Resource
class_name FishingStats


@export var catchables :Array[CollectedCatchable]
@export var identification_list :Array[IdentifiedRes] = []
@export var current_lure :CatchableRes = preload("res://scripts/Resources/Catchables/Lure.tres")
@export var money :int = 0
var starter_identification_list = preload("res://scripts/Resources/Identification/IdentificationListStarter.tres")


func _init():
	catchables.append(CollectedCatchable.create(current_lure))
	for item in starter_identification_list.entries:
		identification_list.append(IdentifiedRes.create(item))


func update_money(amount :int):
	money += amount
	SignalBus.money_changed.emit(money)
	SignalBus.save_requested.emit()


func try_pay(amount :int) -> bool:
	if money - amount < 0:
		return false
	
	update_money(-amount)
	return true


func contains(catchable :CatchableRes) -> bool:
	for c in catchables:
		if c.catchable == catchable:
			return true
	return false


func get_catchable_by_res(catchable :CatchableRes) -> CollectedCatchable:
	var collected_catchable = catchables.filter(func (c): c.catchable == catchable)
	if not collected_catchable.is_empty():
		return collected_catchable[0]
	return null
