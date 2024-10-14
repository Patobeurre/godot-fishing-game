extends Node3D


@onready var state_machine : FiniteStateMachine = $FiniteStateMachine
@onready var default_state : StateMachineState = $FiniteStateMachine/DefaultState
@onready var playable_state : StateMachineState = $FiniteStateMachine/PlayableState
@onready var playable_state_path : NodePath = "PlayableState"
@onready var completed_state_path : NodePath = "CompletedState"

@onready var boundaries = $Boundaries
@onready var counters = $Counters

var coord := Vector2.ZERO

signal area_completed(pos: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready():
	playable_state.timer_changed.connect(_on_timer_changed)
	playable_state.timer_timeout.connect(_on_area_completed)
	state_machine.set_current_state(default_state)
	pass # Replace with function body.


func _on_timer_changed(time):
	counters.update_all(int(time))

func _on_area_3d_body_entered(body):
	if default_state.is_current_state():
		state_machine.change_state(playable_state_path)
	

func _on_area_completed():
	counters.visible = false
	state_machine.change_state(completed_state_path)
	area_completed.emit(coord)
