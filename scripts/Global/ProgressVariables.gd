extends Node


var progress :Dictionary = {
	"fishing_gear_obtained" : true
	
}

signal progress_variable_updated(String)


func update_progress_variable(name :String, value):
	if not progress.has(name):
		return
	
	if progress[name] != value:
		progress[name] = value
		progress_variable_updated.emit(name)
