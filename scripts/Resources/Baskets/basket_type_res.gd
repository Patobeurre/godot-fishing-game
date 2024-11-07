extends Resource
class_name BasketTypeRes


enum EBasketType {
	SIMPLE,
	MEDIUM,
	LARGE,
	NEST
}

@export var image :Texture2D
@export var scene :PackedScene
@export var name :String
@export var description :String
@export var price :int
@export var type :EBasketType = EBasketType.SIMPLE
@export var max_size :int = 5
@export var time_interval :float = 10.0
@export var min_rarity :Rarity.ERarity = Rarity.ERarity.COMMON
