extends RigidBody2D


@export var minigame_res :MiniGameFollowRes
@export var speed :float = 6

@onready var sprite := $Sprite2D
@onready var animation_player := $AnimationPlayer

var collider :CollisionPolygon2D


func _ready() -> void:
	visible = false

func setup_sprite():
	sprite.texture = minigame_res.minigame_sprite
	sprite.modulate = Color.from_hsv(0, 0, 0)
	if not minigame_res.animation_name.is_empty():
		animation_player.play(minigame_res.animation_name)

func init(res :MiniGameFollowRes):
	minigame_res = res
	setup_sprite()
	visible = true
