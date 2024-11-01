extends Resource
class_name IdentifiedRes

@export var catchable :IdentificationCatchable

var unknown_picture := preload("res://sprites/Catchables/unknown.png")

@export var selected_catchable :CatchableRes = null
@export var is_correctly_identified :bool = false


static func create(new_identification_catchable :IdentificationCatchable) -> IdentifiedRes:
	var identified_catchable = IdentifiedRes.new()
	identified_catchable.catchable = new_identification_catchable
	return identified_catchable


func get_picture() -> Texture2D:
	if selected_catchable != null:
		return selected_catchable.image
	return unknown_picture


func verify() -> bool:
	return catchable.matching_catchable == selected_catchable
