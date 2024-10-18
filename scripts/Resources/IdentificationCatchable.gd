extends Resource
class_name IdentificationCatchable

@export var matching_catchable :CatchableRes
@export var name :String
@export var size :String
@export var habitat :String
@export var description :String

var unknown_picture := preload("res://sprites/Catchables/unknown.png")

var selected_catchable :CatchableRes = null
var is_correctly_identified :bool = false


func get_picture() -> Texture2D:
	if selected_catchable != null:
		return selected_catchable.image
	return unknown_picture


func verify() -> bool:
	is_correctly_identified = (matching_catchable == selected_catchable)
	return is_correctly_identified
