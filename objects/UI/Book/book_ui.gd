extends Node3D


@onready var animation_player := $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func open_book() -> void:
	visible = true
	animation_player.play("ArmatureAction")

func close_book() -> void:
	animation_player.play("ArmatureAction", -1, 1, true)
	await animation_player.animation_finished
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
