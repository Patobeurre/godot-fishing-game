extends Control


@onready var wave_node = $Waves
@onready var cursor = $Cursor
@onready var timer = $Timer

@onready var wave_part_scene = preload("res://objects/UI/wave_part.tscn")

@export var cooldown :float = 2

var width :float
var height :float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = size.x
	height = size.y
	
	cursor.global_position = Vector2(width / 2, height / 2)
	wave_node.global_position = Vector2(width / 2, height / 2)
	
	timer.start(cooldown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_move_cursor()


func _move_cursor() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	cursor.look_at(mouse_position)


func spawn_wave_part() -> void:
	for i in range(15):
		if i == 3 or i == 10 or i == 11:
			continue
		var obj = wave_part_scene.instantiate()
		wave_node.add_child(obj)
		obj.global_position = wave_node.global_position
		obj.rotation = deg_to_rad(i*24)


func _on_timer_timeout() -> void:
	spawn_wave_part()
	timer.start(cooldown)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("entered")


func _on_area_2d_area_exited(area: Area2D) -> void:
	print("exited")
