extends Resource
class_name IdentificationCatchable

@export var matching_catchable :CatchableRes
@export var name :String
@export var size :String
@export var habitat :String
@export var description :String

var selected_catchable :CatchableRes = null
var is_identified :bool = false
