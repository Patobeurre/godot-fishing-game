extends Node
class_name Rarity

enum ERarity {
	DEFAULT = 0,
	COMMON = 50,
	UNCOMMON = 30,
	RARE = 15,
	LEGENDARY = 5,
}

static func to_text(rarity :ERarity) -> String:
	if rarity == ERarity.COMMON:
		return "F_RARITY_COMMON"
	if rarity == ERarity.UNCOMMON:
		return "F_RARITY_UNCOMMON"
	if rarity == ERarity.RARE:
		return "F_RARITY_RARE"
	if rarity == ERarity.LEGENDARY:
		return "F_RARITY_LEGENDARY"
	return ""

static func get_rarity (rngNumber: int) :
	if rngNumber > ERarity.COMMON:
		return ERarity.COMMON
	if rngNumber > ERarity.UNCOMMON:
		return ERarity.UNCOMMON
	if rngNumber > ERarity.RARE:
		return ERarity.RARE
	else:
		return ERarity.LEGENDARY
