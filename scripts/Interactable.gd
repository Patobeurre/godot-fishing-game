extends Node3D


@export var interact_text :String = "interact"
var disabled :bool = false

signal interact_performed


func _ready():
	self.add_to_group("Interactable")


func interact() -> void:
	if disabled: return
	interact_performed.emit()


func set_enabled(enabled :bool):
	disabled = not enabled

func is_disabled() -> bool:
	return disabled
