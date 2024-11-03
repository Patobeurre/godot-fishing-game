extends Node3D


@onready var interact_body = $Cube/StaticBody3D
@onready var camera = $Camera3D

@onready var time_label = $SubViewport/MarginContainer2/VSplitContainer/VBoxContainer/HBoxContainer/TimeLabel
@onready var temperature_label = $SubViewport/MarginContainer2/VSplitContainer/VBoxContainer/HBoxContainer2/TemperatureLabel
@onready var humidity_label = $SubViewport/MarginContainer2/VSplitContainer/VBoxContainer/HBoxContainer3/HumidityLabel
@onready var rotation_label = $SubViewport/MarginContainer2/VSplitContainer/VBoxContainer/HBoxContainer4/RotationLabel
@onready var pollution_label = $SubViewport/MarginContainer2/VSplitContainer/VBoxContainer/HBoxContainer5/PollutionLabel


func _ready() -> void:
	interact_body.interact_performed.connect(_on_interact_performed)
	SignalBus.time_changed.connect(_on_time_changed)
	TimeManager.rotation_changed.connect(update_rotation)


func update_time(time_ratio :float) -> void:
	var hours :int = floor(time_ratio * 24)
	var minutes :int = fmod(time_ratio * 24 * 60, 60)
	time_label.text = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2)

func update_temperature(temperature :float) -> void:
	temperature_label.text = ("%3.1f" % temperature) + "°C"

func update_humidity(humidity :int) -> void:
	humidity_label.text = str(humidity) + "%"

func update_rotation(rotation :float) -> void:
	rotation_label.text = str(rotation) + "°"

func update_pollution(pollution :int) -> void:
	pollution_label.text = str(pollution) + "%"


func _on_time_changed(time :float):
	update_time(TimeManager.get_time_ratio())
	update_temperature(TimeManager.time_stats.temperature)
	update_humidity(TimeManager.time_stats.humidity)
	update_pollution(TimeManager.time_stats.pollution)


func _on_interact_performed():
	_on_time_changed(0)
	update_rotation(TimeManager.time_stats.rotation)
	SignalBus.interact_request.emit(camera)
