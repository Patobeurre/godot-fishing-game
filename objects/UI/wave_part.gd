extends Area2D
class_name WavePart


@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.visible = false
	animation_player.play("grow")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
