extends Node


var progress :Dictionary = {
	"fishing_gear_obtained" : true,
	"identification_book_obtained" : true,
}

signal progress_variable_updated(String)


func update_progress_variable(name :String, value):
	if not progress.has(name):
		return
	
	if progress[name] != value:
		progress[name] = value
		progress_variable_updated.emit(name)


func check_variable(name :String, value) -> bool:
	return progress[name] == value
