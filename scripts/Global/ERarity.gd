extends Node
class_name Rarity

enum ERarity {
	DEFAULT = 0,
	COMMON = 50,
	UNCOMMON = 30,
	RARE = 15,
	LEGENDARY = 5,
}

static func get_rarity (rngNumber: int) :
	if rngNumber > ERarity.COMMON:
		return ERarity.COMMON
	if rngNumber > ERarity.UNCOMMON:
		return ERarity.UNCOMMON
	if rngNumber > ERarity.RARE:
		return ERarity.RARE
	else:
		return ERarity.LEGENDARY
