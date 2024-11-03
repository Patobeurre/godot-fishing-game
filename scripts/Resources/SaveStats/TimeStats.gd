extends Resource
class_name TimeStats


const MAX_TIME_RANGE :float = 2400
const rotation_step :float = 10.0
const temperature_curve :Curve = preload("res://scripts/Resources/TemperatureCurve.tres")
const humidity_curve :Curve = preload("res://scripts/Resources/HumidityCurve.tres")

@export var day_count :int = 0
@export var time_of_day :float = 900
@export var current_period :TimePeriod.ETimePeriod = TimePeriod.ETimePeriod.DAY
@export var rotation = 0
@export var temperature :float = 0
@export var humidity :float = 0
@export var pollution :int = 0


func set_time_of_day(newTimeOfDay :float) -> void:
	time_of_day = newTimeOfDay
	temperature = temperature_curve.sample(time_of_day / MAX_TIME_RANGE)
	humidity = humidity_curve.sample(time_of_day / MAX_TIME_RANGE)
	#SignalBus.time_changed.emit(time_of_day)
	_update_current_period()

func set_day_count(newDayCount :int) -> void:
	day_count = newDayCount
	add_rotation(rotation_step)
	SignalBus.save_requested.emit()
	TimeManager.new_day.emit(day_count)


func add_rotation(new_rotation):
	rotation += new_rotation
	rotation = fmod(rotation, 360)
	TimeManager.rotation_changed.emit(rotation)


func _update_current_period():
	var newPeriod = TimePeriod.to_period(time_of_day)
	if current_period != newPeriod:
		current_period = newPeriod
		SignalBus.time_period_changed.emit(current_period)
		SignalBus.save_requested.emit()
