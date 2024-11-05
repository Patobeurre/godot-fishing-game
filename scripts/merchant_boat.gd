extends Node3D


@onready var interact_body = $StaticBody3D
@onready var collision = $StaticBody3D/CollisionShape3D
@onready var animation_player = $AnimationPlayer

@export var activation_periods :Array[TimePeriod.ETimePeriod] = []


func _ready() -> void:
	visible = false
	collision.disabled = true
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	interact_body.interact_performed.connect(_on_interact)
	SignalBus.time_period_changed.connect(_on_time_period_changed)


func _on_time_period_changed(period :TimePeriod.ETimePeriod):
	if activation_periods.has(period):
		_activate()
	elif visible:
		_deactivate()


func _activate():
	animation_player.play("appear")
	visible = true
	collision.disabled = false

func _deactivate():
	animation_player.play("disappear")
	visible = false
	collision.disabled = true


func _on_savegame_loaded():
	if activation_periods.has(TimeManager.time_stats.current_period):
		_activate()


func _on_interact():
	UiManager.open("MerchantMenu")
