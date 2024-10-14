extends Node3D


@onready var interact_body = $bed_merged_001/StaticBody3D


func _ready() -> void:
	interact_body.interact_performed.connect(interact)


func interact():
	UiManager.open("TimeChanger")
