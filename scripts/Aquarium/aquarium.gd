extends Node3D


@onready var interact_body = $Cube_224/StaticBody3D


func _ready() -> void:
	interact_body.interact_performed.connect(_on_interact)


func _on_interact() -> void:
	pass


func _process(delta: float) -> void:
	pass
