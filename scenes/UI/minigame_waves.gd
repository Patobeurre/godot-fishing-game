extends Control
class_name MiniGameWaves

@onready var wave_node = $Waves
@onready var cursor = $Cursor
@onready var container = $CursorContainer
@onready var timebar_node = $TimebarNode
@onready var timebar = $TimebarNode/Timebar
@onready var timer_interval = $Cooldown
@onready var timer_main = $TimebarNode/Timer
@onready var catchable_img = $CatchableImg

@onready var wave_part_scene = preload("res://objects/UI/wave_part.tscn")

@export var cooldown :float = 2

var width :float
var height :float

var score :float = 1
var score_max :float = 100
var score_step :float = 10
var score_fail_value :float = -30
var is_win :bool = false

var rotation_speed :float = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = size.x
	height = size.y
	
	cursor.global_position = Vector2(width / 2, height / 2)
	wave_node.global_position = Vector2(width / 2, height / 2)
	catchable_img.global_position = Vector2(width / 2, height / 2)
	container.global_position = Vector2(width / 2, height / 2)
	timebar_node.global_position = Vector2(width / 2, 5*height / 6)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	timer_interval.start(cooldown)
	timer_main.start(10)


func init(catchable :CatchableRes):
	if catchable != null:
		catchable_img.texture = catchable.shadow


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	print(score)
	if _check_game_finished():
		return
	
	_move_cursor()
	
	_update_score(score_step * delta)
	timebar.scale.x = score * 16 / score_max
	
	wave_node.rotate(deg_to_rad(rotation_speed*delta))


func _check_game_finished():
	if score >= score_max:
		is_win = true
		end_game()
		return true
	elif score <= 0:
		is_win = false
		end_game()
		return true
	
	return false


func end_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.end_minigame.emit(is_win)


func _update_score(value :float):
	score += value
	if score < 0:
		score = 0
	if score > score_max:
		score = score_max


func _move_cursor() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	cursor.look_at(mouse_position)


func spawn_wave_part() -> void:
	var indices := []
	while indices.size() < 3:
		var rnd := randi_range(0, 14)
		if not indices.has(rnd):
			indices.append(rnd)
	
	for i in range(15):
		if indices.has(i):
			continue
		var obj = wave_part_scene.instantiate()
		wave_node.add_child(obj)
		obj.global_position = wave_node.global_position
		obj.rotation = deg_to_rad(i*24)
	


func _on_timer_timeout() -> void:
	spawn_wave_part()
	timer_interval.start(cooldown)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("entered")
	_update_score(score_fail_value)


func _on_area_2d_area_exited(area: Area2D) -> void:
	print("exited")
