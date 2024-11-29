extends Node3D


@onready var glimmers :GPUParticles3D = $Glimmers

@export var mesh :MeshInstance3D
@export var outline_shader :Material
@export var correct_angle :float
@export var activation_period :TimePeriod.ETimePeriod


func _ready() -> void:
	_deactivate()
	SignalBus.time_period_changed.connect(_on_timeperiod_changed)
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)


func _activate():
	mesh.material_overlay = outline_shader
	glimmers.emitting = true


func _deactivate():
	mesh.material_overlay =  Material.new()
	glimmers.emitting = false


func _check_activation(period :TimePeriod.ETimePeriod):
	if period == activation_period:
		if TimeManager.time_stats.rotation == correct_angle:
			_activate()
	else:
		_deactivate()


func _on_timeperiod_changed(period :TimePeriod.ETimePeriod) -> void:
	_check_activation(period)


func _on_savegame_loaded() -> void:
	_check_activation(TimeManager.get_time_period())
