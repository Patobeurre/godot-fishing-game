extends Control
class_name MiniGameRoundDodge

@onready var cursor = $Center/Cursor
@onready var center = $Center
@onready var container = $CursorContainer

@onready var left_spawner = $Spawners/LeftSpawner
@onready var right_spawner = $Spawners/RightSpawner

@onready var timebar_node = $TimebarNode
@onready var timebar = $TimebarNode/Timebar
@onready var timer_interval = $Cooldown
@onready var timer_main = $TimebarNode/Timer

@onready var catchable_dodge_scene := preload("res://scenes/UI/MiniGame/MinigameDodgeCatchable.tscn")
@onready var gradient := preload("res://materials/minigame_bar_gradient.tres")

@export var minigame_res :MiniGameGenericRes
@export var cooldown :float = 2
@export var cursor_speed :float = 2
@export var cursor_area_radius :float = 220

var width :float
var height :float

var score :float = 1
var score_max :float = 100
var score_step :float = 10
var score_fail_value :float = -30
var is_win :bool = false

var is_cursor_inside_area = false
var spawn_left :bool = true
var input_mouse := Vector2.ZERO
var mouse_sensitivity = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = size.x
	height = size.y
	
	var center_pos = Vector2(width / 2, height / 2)
	
	cursor.global_position = center_pos
	center.global_position = center_pos
	container.global_position = center_pos
	timebar_node.global_position = Vector2(width / 2, 5*height / 6)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	score = score_max - 1
	
	timer_interval.start(cooldown)
	timer_main.start(10)


func init(catchable :CatchableRes):
	if catchable != null:
		minigame_res = catchable.minigame_res


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _check_game_finished():
		return
	
	_move_cursor(delta)
	
	_update_score(-score_step * delta)
	timebar.scale.x = score * 16 / score_max
	#modulate_color(score / score_max)
	
	if Input.is_action_just_pressed("mouse_left"):
		if is_cursor_inside_area:
			_update_score(score_step)


func _input(event):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity


func _move_cursor(delta :float) -> void:
	cursor.position += input_mouse * mouse_sensitivity * cursor_speed
	#cursor.move_and_collide(input_mouse * cursor_speed * mouse_sensitivity)
	cursor.position = cursor.position.limit_length(cursor_area_radius)
	
	input_mouse = Vector2.ZERO


func _check_game_finished():
	if score >= score_max:
		is_win = false
		end_game()
		return true
	elif score <= 0:
		is_win = true
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


func modulate_color(score_ratio :float):
	print(score_ratio)
	timebar.modulate = gradient.gradient.sample(score_ratio)


func spawn_catchable():
	var catchable_scene = catchable_dodge_scene.instantiate()
	var is_reversed :bool = false
	if spawn_left:
		left_spawner.add_child(catchable_scene)
	else:
		right_spawner.add_child(catchable_scene)
		is_reversed = true
	spawn_left = !spawn_left
	catchable_scene.init(minigame_res, cursor, is_reversed)


func _on_timer_timeout() -> void:
	spawn_catchable()
	timer_interval.start(cooldown)


func _on_cursor_area_entered(area: Area2D) -> void:
	print("entered")
	_update_score(-score_fail_value)
	is_cursor_inside_area = true

func _on_cursor_area_exited(area: Area2D) -> void:
	print("exited")
	is_cursor_inside_area = false
