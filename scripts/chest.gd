extends Node3D
class_name ChestNode


@onready var animation_player :AnimationPlayer = $AnimationPlayer


func init():
	animation_player.play("Pop_ground")
	#animation_player.animation_finished.connect()
