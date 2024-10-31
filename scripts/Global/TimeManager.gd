extends Node


const MAX_TIME_RANGE :float = 2400
const NEW_DAY_TIME :float = 1000
const MIDNIGHT_DAY_TIME :float = 600

#@export_range(0, MAX_TIME_RANGE, 0.01) var timeOfDay : float = 1100
@export var rateOfTime : float = 100 / 60

#var day_count :int = 1

var time_stats :TimeStats
var current_period :TimePeriod.ETimePeriod

var is_running = true

signal new_day(int)


func _physics_process(delta):
	if not is_running: return
	if time_stats == null: return
	
	set_time_of_day(time_stats.time_of_day + rateOfTime * delta)
	
	if time_stats.time_of_day > MAX_TIME_RANGE:
		time_stats.set_time_of_day(0.0)
	if time_stats.time_of_day >= MIDNIGHT_DAY_TIME and \
		time_stats.time_of_day < (MIDNIGHT_DAY_TIME + delta):
		Audio.play("sounds/gear_mechanism.ogg")


func stop():
	is_running = false


func resume():
	is_running = true


func set_time_of_day(newTimeOfDay :float):
	_update_day_count(time_stats.time_of_day, newTimeOfDay)
	time_stats.set_time_of_day(newTimeOfDay)


func _update_day_count(begin :float, end :float):
	if end < begin:
		begin -= MAX_TIME_RANGE
	
	if begin < NEW_DAY_TIME and end > NEW_DAY_TIME:
		time_stats.set_day_count(time_stats.day_count + 1)


func get_time_period() -> TimePeriod.ETimePeriod:
	return time_stats.current_period


func get_time_ratio() -> float:
	return time_stats.time_of_day / MAX_TIME_RANGE


func set_stats(stats :TimeStats):
	time_stats = stats
	if time_stats.day_count == 0:
		time_stats.set_day_count(1)
