extends Resource
class_name FishingAreaRes

enum EAreaType {
	NONE,
	WATER,
	
}

@export var name :String
@export var type :EAreaType
@export var waiting_time :float = 3.0
@export var catchables: Array[CatchableRes]
@export var default_catchables: Array[CatchableRes]
