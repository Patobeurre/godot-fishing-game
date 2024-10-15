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
		return 2300
	elif period == ETimePeriod.DAY:
		return 1400
	elif period == ETimePeriod.DAWN:
		return 1180
	elif period == ETimePeriod.NIGHT:
		return 200
	
	return 0

static func to_period(value :float) -> ETimePeriod:
	if value >= 2300:
		return ETimePeriod.DUSK
	elif value >= 1400:
		return ETimePeriod.DAY
	elif value >= 1100:
		return ETimePeriod.DAWN
	elif value >= 200:
		return ETimePeriod.NIGHT
	else:
		return ETimePeriod.DUSK
	
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
