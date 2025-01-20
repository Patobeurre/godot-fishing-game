extends Area2D
class_name MinigameBar


@export var minigame_anim_res :MinigameAnimRes
@export var gradient :GradientTexture1D

@onready var sprite :NinePatchRect = $NinePatchRect
@onready var collision_shape :CollisionShape2D = $CollisionShape2D

var offset_x :int
var initial_pos :Vector2
var elapsed :float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = sprite.global_position
	offset_x = 217


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_position()
	_update_size()
	
	elapsed += delta
	if elapsed > minigame_anim_res.speed:
		elapsed = 0


func _update_size():
	var cur_size_x = minigame_anim_res.sizeX.curve.sample(elapsed / minigame_anim_res.speed)
	sprite.size.x = cur_size_x
	sprite.global_position.x -= cur_size_x/2
	collision_shape.shape.extents = Vector2(sprite.size.x/2, 20)


func _update_position():
	var pos = minigame_anim_res.positionX.curve.sample(elapsed / minigame_anim_res.speed)
	pos = pos / 100 * offset_x
	pos = correct_position_x(pos)
	sprite.global_position.x = initial_pos.x + pos
	collision_shape.global_position.x = initial_pos.x + pos


func correct_position_x(posX :float) -> float:
	if (posX - sprite.size.x / 2) < -offset_x:
		posX = -offset_x + sprite.size.x / 2
	elif (posX + sprite.size.x / 2) > offset_x:
		posX = offset_x - sprite.size.x / 2
	return posX


func modulate_color(score_ratio :float):
	print(gradient.gradient.sample(score_ratio))
	sprite.modulate = gradient.gradient.sample(score_ratio)


func init(minigame_res :MinigameAnimRes, pos :Vector2, offset: int):
	minigame_anim_res = minigame_res
	initial_pos = pos
	offset_x = offset
	position = pos


func set_stats(stats :MinigameAnimRes):
	minigame_anim_res = stats
