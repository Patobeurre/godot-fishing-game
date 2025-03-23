extends Control


@onready var animation_player := $AnimationPlayer
@onready var timer := $Timer


func _ready() -> void:
	animation_player.play("reveal_splash_screen")
	await animation_player.animation_finished
	timer.start()


func _on_timer_timeout() -> void:
	animation_player.play_backwards("reveal_splash_screen")
	await animation_player.animation_finished
	Global.goto_scene("res://scenes/island_final.tscn")
