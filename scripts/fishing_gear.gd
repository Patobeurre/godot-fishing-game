extends Node3D


@onready var interact_body = $StaticBody3D
@onready var collision = $StaticBody3D/CollisionShape3D


func _ready() -> void:
	interact_body.interact_performed.connect(interact)


func interact():
	collision.disabled = true
	ProgressVariables.update_progress_variable("fishing_gear_obtained", true)
	queue_free()
