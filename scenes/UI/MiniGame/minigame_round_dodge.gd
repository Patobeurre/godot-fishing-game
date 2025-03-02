extends Control
class_name MiniGameRoundDodge

@onready var cursor = $Center/Cursor
@onready var center = $Center
@onready var container = $CursorContainer
@onready var timebar_node = $TimebarNode
@onready var timebar = $TimebarNode/Timebar
@onready var timer_interval = $Cooldown
@onready var timer_main = $TimebarNode/Timer

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

var nb_bar_spawn :int = 3
var is_cursor_inside_area = false
var colliding_bar = null

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
	
	timer_interval.start(cooldown)
	timer_main.start(10)
	
	score_step = 100 / nb_bar_spawn
	
	spawn_bars()


func init(catchable :CatchableRes):
	if catchable != null:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _check_game_finished():
		return
	
	_move_cursor(delta)
	
	timebar.scale.x = score * 16 / score_max
	
	if Input.is_action_just_pressed("mouse_left"):
		if is_cursor_inside_area:
			_update_score(score_step)
	


func _input(event):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity


func _move_cursor(delta :float) -> void:
	cursor.move_and_collide(input_mouse * cursor_speed * mouse_sensitivity)	
	cursor.position = cursor.position.limit_length(cursor_area_radius)
	
	input_mouse = Vector2.ZERO


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


func spawn_bars() -> void:
	pass


func _on_timer_timeout() -> void:
	timer_interval.start(cooldown)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("entered")
	colliding_bar = area
	is_cursor_inside_area = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	print("exited")
	colliding_bar = null
	is_cursor_inside_area = false
