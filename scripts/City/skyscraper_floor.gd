extends Node3D
class_name SkyscraperFloor


@onready var floor_mesh := $base_floor_001
@onready var floor_fundation := $floor_fundation

const MAX_STATE :int = 2
var state :int = 0


func _ready() -> void:
	set_state(0)


func increment_state() -> void:
	set_state(state + 1)


func set_state(newState :int) -> void:
	if newState > MAX_STATE:
		return
	
	state = newState
	update_appearence()


func is_completed() -> bool:
	return state == MAX_STATE

func update_appearence() -> void:
	floor_fundation.visible = (state == 1)
	floor_mesh.visible = (state >= 2)
