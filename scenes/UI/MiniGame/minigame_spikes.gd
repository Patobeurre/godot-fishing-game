extends Control
class_name MiniGameSpikes

@onready var spikes_node = $Spikes
@onready var cursor = $Cursor
@onready var container = $CursorContainer
@onready var timebar_node = $TimebarNode
@onready var timebar = $TimebarNode/Timebar
@onready var timer_interval = $Cooldown
@onready var timer_main = $TimebarNode/Timer
@onready var catchable_img = $CatchableImg

@onready var spike_scene = preload("res://objects/UI/spike.tscn")

@export var cooldown :float = 2.0

var width :float
var height :float

var score :float = 1
var score_max :float = 100
var score_step :float = 5
var score_fail_value :float = -30
var is_win :bool = false
var cursor_collision_enabled :bool = true

var rotation_speed :float = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = size.x
	height = size.y
	
	cursor.global_position = Vector2(width / 2, height / 2)
	spikes_node.global_position = Vector2(width / 2, height / 2)
	catchable_img.global_position = Vector2(width / 2, height / 2)
	container.global_position = Vector2(width / 2, height / 2)
	timebar_node.global_position = Vector2(width / 2, 5*height / 6)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	timer_interval.start(cooldown)
	timer_main.start(10)


func init(catchable :CatchableRes):
	if catchable != null:
		catchable_img.texture = catchable.image
		catchable_img.modulate = Color.from_hsv(0, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _check_game_finished():
		return
	
	_move_cursor()
	
	_update_score(score_step * delta)
	timebar.scale.x = score * 16 / score_max


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
	pass


func _update_score(value :float):
	score += value
	if score < 0:
		score = 0
	if score > score_max:
		score = score_max


func _move_cursor() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	cursor.look_at(mouse_position)


func spawn_spikes() -> void:
	var indices := []
	while indices.size() < 3:
		var rnd := randi_range(0, 14)
		if not indices.has(rnd):
			indices.append(rnd)
	
	spikes_node.rotation_degrees = randi_range(0, 360)
	
	for i in range(15):
		if indices.has(i):
			continue
		var obj = spike_scene.instantiate()
		spikes_node.add_child(obj)
		obj.global_position = spikes_node.global_position
		obj.rotation = deg_to_rad(i*24)


func _on_timer_timeout() -> void:
	spawn_spikes()
	cursor_collision_enabled = true
	timer_interval.start(cooldown)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("entered")
	if not cursor_collision_enabled:
		return
	cursor_collision_enabled = false
	_update_score(score_fail_value)


func _on_area_2d_area_exited(area: Area2D) -> void:
	print("exited")
