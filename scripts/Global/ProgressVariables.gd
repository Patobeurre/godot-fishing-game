extends Node


var stats :ProgressVariablesStats = ProgressVariablesStats.new()

signal progress_variable_updated(String)


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)


func update_progress_variable(name :String, value):
	if not stats.progress.has(name):
		return
	
	if stats.progress[name] != value:
		stats.progress[name] = value
		progress_variable_updated.emit(name)


func update_all():
	for key in stats.progress.keys():
		progress_variable_updated.emit(key)


func check_variable(name :String, value) -> bool:
	return stats.progress[name] == value


func set_stats(new_stats :ProgressVariablesStats):
	stats = new_stats


func _on_savegame_loaded():
	update_all()
