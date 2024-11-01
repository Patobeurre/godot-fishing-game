extends Resource
class_name TimeStats


@export var day_count :int = 0
@export var time_of_day :float = 0
@export var current_period :TimePeriod.ETimePeriod = TimePeriod.ETimePeriod.DAY


func set_time_of_day(newTimeOfDay :float) -> void:
	time_of_day = newTimeOfDay
	_update_current_period()

func set_day_count(newDayCount :int) -> void:
	day_count = newDayCount
	SignalBus.save_requested.emit()
	TimeManager.new_day.emit(day_count)

func _update_current_period():
	var newPeriod = TimePeriod.to_period(time_of_day)
	if current_period != newPeriod:
		current_period = newPeriod
		SignalBus.time_period_changed.emit(current_period)
		SignalBus.save_requested.emit()
