extends Node3D


@export var interact_text :String = "interact"

signal interact_performed


func _ready():
	self.add_to_group("Interactable")


func interact() -> void:
	interact_performed.emit()
