extends Control


@export var minigame_anim_res :MinigameAnimRes

var initial_pos :Vector2
var elapsed :float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = $Area2D/NinePatchRect.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_position()
	_update_size()
	
	elapsed += delta
	if elapsed > minigame_anim_res.speed:
		elapsed = 0


func _update_size():
	var cur_size_x = minigame_anim_res.sizeX.curve.sample(elapsed / minigame_anim_res.speed)
	$Area2D/NinePatchRect.size.x = cur_size_x
	$Area2D/NinePatchRect.global_position.x -= cur_size_x/2
	$Area2D/CollisionShape2D.shape.extents = Vector2($Area2D/NinePatchRect.size.x/2, 20)


func _update_position():
	var pos = minigame_anim_res.positionX.curve.sample(elapsed / minigame_anim_res.speed)
	$Area2D/NinePatchRect.global_position.x = initial_pos.x + pos
	$Area2D/CollisionShape2D.global_position.x = initial_pos.x + pos


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	$Label.visible = true


func _on_area_2d_2_area_exited(area: Area2D) -> void:
	$Label.visible = false
