extends Node3D

@onready var interact_body := $computer/computer/StaticBody3D
@onready var camera := $Camera3D

@onready var electric_eel := $ElectricEel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	SignalBus.new_lure_registered.connect(_on_new_lure_registered)
	interact_body.interact_performed.connect(interact)


func interact():
	SignalBus.interact_request.emit(camera)


func enable_computer():
	electric_eel.visible = true


func disable_computer():
	electric_eel.visible = false


func _on_new_lure_registered(catchable :CatchableRes):
	if catchable.id == 68: # electric eel fish ID
		ProgressVariables.update_progress_variable("electric_eel_obtained", true)
		enable_computer()


func _on_savegame_loaded():
	if ProgressVariables.check_variable("electric_eel_obtained", true):
		enable_computer()
	else:
		disable_computer()
