extends Node3D


@onready var interact_body = $Cube_223/StaticBody3D
@onready var collision = $Cube_223/StaticBody3D/CollisionShape3D


func _ready() -> void:
	interact_body.interact_performed.connect(interact)
	ProgressVariables.progress_variable_updated.connect(_on_progress_variables_updated)


func interact():
	ProgressVariables.update_progress_variable("identification_book_obtained", true)
	_destroy()


func _destroy():
	collision.disabled = true
	ProgressVariables.progress_variable_updated.disconnect(_on_progress_variables_updated)
	queue_free()


func _on_progress_variables_updated(variable_name :String) -> void:
	if ProgressVariables.check_variable("identification_book_obtained", true):
		_destroy()
