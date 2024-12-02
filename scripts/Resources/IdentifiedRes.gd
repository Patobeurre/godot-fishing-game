extends Resource
class_name IdentifiedRes

@export var catchable :IdentificationCatchable

static var unknown_catchable :CatchableRes = preload("res://scripts/Resources/Catchables/Unknown.tres")

@export var selected_catchable :CatchableRes = null
@export var is_correctly_identified :bool = false


static func create(new_identification_catchable :IdentificationCatchable) -> IdentifiedRes:
	var identified_catchable = IdentifiedRes.new()
	identified_catchable.catchable = new_identification_catchable
	return identified_catchable


func get_picture() -> Texture2D:
	#if is_correctly_identified:
	#	selected_catchable = catchable.matching_catchable
	return selected_catchable.image


func verify() -> bool:
	return catchable.matching_catchable == selected_catchable
