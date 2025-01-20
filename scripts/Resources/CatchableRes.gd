extends Resource
class_name CatchableRes

enum ELureTag {
	FISH,
	SMALL_FISH,
	MEDIUM_FISH,
	BIG_FISH,
	INSECT,
	NUT,
	BIRD,
	CRUSTACEAN,
	BOOKWORM,
	MULTIPLE_LEGS,
	SWEET,
	STATIC,
	NONE,
}

@export var id :int
@export var name: String
@export var description: String
@export var notification_text: String
@export var category: CategoryRes
@export var tags: Array[ELureTag]
@export var image: Texture2D
@export var shadow: Texture2D
@export var scene: PackedScene
@export var minigame_res: MinigameAnimRes
@export var rarity: Rarity.ERarity
@export var price: int
@export var regions: Array[RegionRes]
@export var periods: Array[TimePeriod.ETimePeriod]
@export var lures: Array[CatchableRes]
@export var lure_ids: Array[int]
@export var lure_tags: Array[ELureTag]


func is_fish() -> bool:
	return tags.has(ELureTag.FISH)


static func get_minigame_difficulty(rarity :Rarity.ERarity) -> MiniGameRes:
	if rarity == Rarity.ERarity.UNCOMMON:
		return preload("res://scripts/Resources/MiniGame/Medium.tres")
	elif rarity == Rarity.ERarity.RARE:
		return preload("res://scripts/Resources/MiniGame/Hard.tres")
	elif rarity == Rarity.ERarity.LEGENDARY:
		return preload("res://scripts/Resources/MiniGame/Extrem.tres")
		
	return preload("res://scripts/Resources/MiniGame/Easy.tres")
