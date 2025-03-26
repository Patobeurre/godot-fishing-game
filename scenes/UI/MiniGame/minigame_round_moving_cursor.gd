extends Control
class_name MiniGameRoundMovingCursor

@onready var bars_node = $Bars
@onready var cursor = $Cursor
@onready var container = $CursorContainer
@onready var timebar_node = $TimebarNode
@onready var timebar = $TimebarNode/Timebar
@onready var timer_interval = $Cooldown
@onready var timer_main = $TimebarNode/Timer
@onready var catchable_img = $CatchableImg

@onready var wave_part_scene = preload("res://objects/UI/wave_part.tscn")

@export var minigame_res :MiniGameRes
@export var cooldown :float = 2
@export var cursor_speed :float = 2

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = size.x
	height = size.y
	
	cursor.global_position = Vector2(width / 2, height / 2)
	bars_node.global_position = Vector2(width / 2, height / 2)
	catchable_img.global_position = Vector2(width / 2, height / 2)
	container.global_position = Vector2(width / 2, height / 2)
	timebar_node.global_position = Vector2(width / 2, 5*height / 6)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	timer_interval.start(cooldown)


func init(catchable :CatchableRes):
	if catchable != null:
		catchable_img.texture = catchable.image
		catchable_img.modulate = Color.from_hsv(0, 0, 0)
		minigame_res = catchable.get_minigame_difficulty(catchable.rarity)
		timer_main.start(minigame_res.round_max_time)
		score_step = 100 / minigame_res.round_nb_bar_to_spawn
		spawn_bars()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _check_game_finished():
		return
	
	_move_cursor(delta)
	
	timebar.scale.x = score * 16 / score_max
	
	if Input.is_action_just_pressed("mouse_left"):
		if is_cursor_inside_area:
			_remove_bar(colliding_bar)
			_update_score(score_step)


func _remove_bar(bar):
	bars_node.remove_child(bar)


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


func _move_cursor(delta :float) -> void:
	cursor.rotate(delta * minigame_res.round_cursor_speed)


func spawn_bars() -> void:
	var indices := []
	while indices.size() < minigame_res.round_nb_bar_to_spawn:
		var rnd := randi_range(0, 14)
		if not indices.has(rnd):
			indices.append(rnd)
	
	for i in range(15):
		if indices.has(i):
			var obj = wave_part_scene.instantiate()
			bars_node.add_child(obj)
			obj.global_position = bars_node.global_position
			obj.rotation = deg_to_rad(i*24)
			obj.scale = Vector2(5.7,5.7)


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
