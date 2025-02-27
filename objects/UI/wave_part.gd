extends Area2D
class_name WavePart


@onready var sprite := $Sprite2D
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func play_grow_anim():
	$Sprite2D.visible = false
	animation_player.play("grow")


func modulate(color :Color):
	sprite.modulate(color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
