extends Control


@export var cooldown :float = 2.0

@onready var text_label := $MarginContainer/TextureRect/RichTextLabel
@onready var timer := $Timer

var loading_res :LoadingRes = LoadingRes.new()


func _ready() -> void:
	load_new_text()
	timer.start(cooldown + randf_range(-1, 1))


func load_new_text() -> void:
	text_label.text += "\n" + loading_res.get_random_text() + "..."


func _on_timer_timeout() -> void:
	load_new_text()
	timer.start(cooldown + randf_range(-1, 1))
