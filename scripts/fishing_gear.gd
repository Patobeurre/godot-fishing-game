extends Node3D


@onready var interact_body = $StaticBody3D
@onready var collision = $StaticBody3D/CollisionShape3D


func _ready() -> void:
	interact_body.interact_performed.connect(interact)
	ProgressVariables.progress_variable_updated.connect(_on_progress_variables_updated)


func interact():
	ProgressVariables.update_progress_variable("fishing_gear_obtained", true)
	_destroy()


func _destroy() -> void:
	collision.disabled = true
	ProgressVariables.progress_variable_updated.disconnect(_on_progress_variables_updated)
	queue_free()


func _on_progress_variables_updated(variable_name :String) -> void:
	if ProgressVariables.check_variable("fishing_gear_obtained", true):
		_destroy()
