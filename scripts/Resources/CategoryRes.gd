extends Resource
class_name CategoryRes

enum ELureCategory {
	FISH,
	NATURE,
	INSECT,
	ANIMAL,
	ITEM,
	NONE,
}

@export var name :String
@export var icon :Texture2D
@export var tag :ELureCategory
