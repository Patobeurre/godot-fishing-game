extends Resource
class_name TimeStats


@export var day_count :int = 1
@export var time_of_day :float = 1100


func set_time_of_day(newTimeOfDay :float) -> void:
	time_of_day = newTimeOfDay

func set_day_count(newDayCount :int) -> void:
	day_count = newDayCount
