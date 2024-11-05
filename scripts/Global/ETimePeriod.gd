extends Resource
class_name TimePeriod

enum ETimePeriod {
	DAWN = 0,
	DAY = 1,
	DUSK = 2,
	NIGHT = 3,
}

static func to_value(period :ETimePeriod) -> float:
	if period == ETimePeriod.DUSK:
		return 1650
	elif period == ETimePeriod.DAY:
		return 900
	elif period == ETimePeriod.DAWN:
		return 580
	elif period == ETimePeriod.NIGHT:
		return 2000
	
	return 0

static func to_period(value :float) -> ETimePeriod:
	if value >= to_value(ETimePeriod.NIGHT):
		return ETimePeriod.NIGHT
	elif value >= to_value(ETimePeriod.DUSK):
		return ETimePeriod.DUSK
	elif value >= to_value(ETimePeriod.DAY):
		return ETimePeriod.DAY
	elif value >= to_value(ETimePeriod.DAWN):
		return ETimePeriod.DAWN
	else:
		return ETimePeriod.NIGHT
	
static func to_text(period :ETimePeriod) -> String:
	if period == ETimePeriod.DUSK:
		return "Dusk"
	elif period == ETimePeriod.DAY:
		return "Day"
	elif period == ETimePeriod.DAWN:
		return "Dawn"
	elif period == ETimePeriod.NIGHT:
		return "Night"
	
	return ""
