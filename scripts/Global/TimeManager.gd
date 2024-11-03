extends Node


const rateOfTime : float = 100 / 60

var time_stats :TimeStats

var is_running = true

signal new_day(int)
signal rotation_changed(float)


func _physics_process(delta):
	if not is_running: return
	if time_stats == null: return
	
	set_time_of_day(time_stats.time_of_day + rateOfTime * delta)
	
	if time_stats.time_of_day > time_stats.MAX_TIME_RANGE:
		time_stats.set_time_of_day(0.1)
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
		begin -= time_stats.MAX_TIME_RANGE
	
	if begin < 0 and end > 0:
		time_stats.set_day_count(time_stats.day_count + 1)


func get_time_period() -> TimePeriod.ETimePeriod:
	return time_stats.current_period


func get_time_ratio() -> float:
	return time_stats.time_of_day / time_stats.MAX_TIME_RANGE


func set_stats(stats :TimeStats):
	time_stats = stats
	if time_stats.day_count == 0:
		time_stats.set_day_count(1)
