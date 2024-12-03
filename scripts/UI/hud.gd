extends Control


@onready var fish_collection = $FishCollection
@onready var identification_book = $IdentificationBook
@onready var crosshair = $CenterContainer/TextureRect

@onready var clock_background = $ClockContainer/ClockBackgrond
@onready var clock_needle = $ClockContainer/Needle
@onready var time_label = $ClockContainer/TimeLabel


func _ready() -> void:
	identification_book.visible = false
	clock_needle.position = clock_background.position
	ProgressVariables.progress_variable_updated.connect(_on_progress_variable_updated)


func _process(delta):
	var time_ratio = TimeManager.get_time_ratio()
	var angle = (time_ratio * 360) + 90
	clock_needle.rotation_degrees = angle
	update_time_label(time_ratio)


func update_time_label(time_ratio :float) -> void:
	var time = time_ratio * 1440
	
	var minutes = fmod(time, 60)
	time /= 60
	var hours = fmod(time, 60)
	
	time_label.text = ("%02d:%02d" % [hours, minutes])


func _on_progress_variable_updated(variable_name :String) -> void:
	identification_book.visible = ProgressVariables.check_variable("identification_book_obtained", true)


func enable_crosshair(enabled : bool) -> void:
	crosshair.visible = enabled
