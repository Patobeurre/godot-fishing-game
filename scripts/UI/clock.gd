extends Control


@onready var hand = $CenterContainer/ClockHand

@onready var state_machine := $FiniteStateMachine
@onready var default_state = $DefaultState
@onready var dragging_state = $DraggingState

var is_mouse_in_area :bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand.position = get_viewport_rect().size / 2
	state_machine.set_current_state(default_state)


func start_dragging():
	if is_mouse_in_area:
		state_machine.set_current_state(dragging_state)


func stop_dragging():
	state_machine.set_current_state(default_state)


func drag_to_new_rotation():
	var mouse_pos = get_viewport().get_mouse_position()
	hand.look_at(mouse_pos)


func end_rotation():
	pass


func _on_area_2d_mouse_entered() -> void:
	is_mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	is_mouse_in_area = false
