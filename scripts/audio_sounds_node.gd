extends Node3D


func _ready() -> void:
	
	for audio_player :AudioStreamPlayer3D in get_children():
		audio_player.play()
