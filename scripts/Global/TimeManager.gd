extends Node


const MAX_TIME_RANGE :float = 2400
const NEW_DAY_TIME :float = 1000
const MIDNIGHT_DAY_TIME :float = 600

#@export_range(0, MAX_TIME_RANGE, 0.01) var timeOfDay : float = 1100
@export var rateOfTime : float = 100 / 60

#var day_count :int = 1

var time_stats :TimeStats = TimeStats.new()
var current_period :TimePeriod.ETimePeriod

signal new_day(int)


func _ready():
	current_period = get_time_period()

func _physics_process(delta):
	set_time_of_day(time_stats.time_of_day + rateOfTime * delta)
	
	if time_stats.time_of_day > MAX_TIME_RANGE:
		time_stats.set_time_of_day(0.0)
	if time_stats.time_of_day >= MIDNIGHT_DAY_TIME and \
		time_stats.time_of_day < (MIDNIGHT_DAY_TIME + delta):
		Audio.play("sounds/gear_mechanism.ogg")


func set_time_of_day(newTimeOfDay :float):
	_update_day_count(time_stats.time_of_day, newTimeOfDay)
	time_stats.set_time_of_day(newTimeOfDay)
	_update_current_period()


func _update_current_period():
	var newPeriod = get_time_period()
	if current_period != newPeriod:
		current_period = newPeriod
		SignalBus.save_requested.emit()

func _update_day_count(begin :float, end :float):
	if end < begin:
		begin -= MAX_TIME_RANGE
	
	if begin < NEW_DAY_TIME and end > NEW_DAY_TIME:
		time_stats.set_day_count(time_stats.day_count + 1)
		SignalBus.save_requested.emit()
		new_day.emit(time_stats.day_count)


func get_time_period() -> TimePeriod.ETimePeriod:
	return TimePeriod.to_period(time_stats.time_of_day)


func set_stats(stats :TimeStats):
	time_stats = stats
