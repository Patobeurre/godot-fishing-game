extends Control


@export var cooldown :float = 2.0

@onready var text_label := $MarginContainer/TextureRect/RichTextLabel
@onready var timer := $Timer

var loading_res :LoadingRes = LoadingRes.new()

var next_scene = "res://scenes/island_final.tscn"


func _ready() -> void:
	load_new_text()
	timer.start(cooldown + randf_range(-1, 1))
	ResourceLoader.load_threaded_request(next_scene)


func _process(delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	if progress[0] == 1:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)


func load_new_text() -> void:
	text_label.text += "\n" + loading_res.get_random_text() + "..."


func _on_timer_timeout() -> void:
	load_new_text()
	timer.start(cooldown + randf_range(-1, 1))
