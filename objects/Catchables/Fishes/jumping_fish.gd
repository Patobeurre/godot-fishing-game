extends Node3D


@onready var animation_player := $fish/AnimationPlayer


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func play_animation():
	animation_player.play("ArmatureAction_003")


func _on_animation_finished(name :String) -> void:
	animation_player.animation_finished.disconnect(_on_animation_finished)
	queue_free()
