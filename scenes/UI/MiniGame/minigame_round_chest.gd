extends Control
class_name MiniGameRoundChest

@onready var bars_node = $Bars
@onready var bars_outer = $Bars/Outer
@onready var bars_middle = $Bars/Mid
@onready var bars_inner = $Bars/Inner

@onready var cursor = $Cursor
@onready var cursor_area = $Cursor/Area2D
@onready var container = $CursorContainer
@onready var timebar_node = $TimebarNode
@onready var timebar = $TimebarNode/Timebar
@onready var timer_interval = $Cooldown
@onready var timer_main = $TimebarNode/Timer
@onready var catchable_img = $CatchableImg

@onready var state_machine = $FiniteStateMachine
@onready var default_state = $DefaultState
@onready var on_anomation_state = $OnAnimationState

@onready var wave_part_scene = preload("res://objects/UI/wave_part.tscn")
@onready var gradient := preload("res://materials/minigame_bar_gradient.tres")

@export var cooldown :float = 2
@export var cursor_speed :float = 2

var width :float
var height :float

var score :float = 1
var score_max :float = 100
var score_step :float = 10
var score_fail_value :float = -20
var is_win :bool = false

var nb_bar_spawn :int = 14
var rotation_speed :float = 50
var nb_layer :int = 3
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
	timer_main.start(10)
	
	spawn_bars(bars_outer)
	spawn_bars(bars_middle)
	spawn_bars(bars_inner)
	
	score = score_max - 1
	state_machine.set_current_state(default_state)


func init(catchable :CatchableRes):
	if catchable != null:
		catchable_img.texture = catchable.image
		catchable_img.modulate = Color.from_hsv(0, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _check_game_finished():
		return
	
	_move_cursor()
	_rotate_bars(delta)
	
	_update_score(-score_step * delta)
	timebar.scale.x = score * 16 / score_max
	modulate_color(score / score_max)


func _rotate_bars(delta :float) -> void:
	bars_outer.rotate(deg_to_rad(rotation_speed * delta))
	bars_middle.rotate(deg_to_rad(-rotation_speed * delta))
	bars_inner.rotate(deg_to_rad(rotation_speed * delta))


func _check_game_finished():
	if nb_layer == 0:
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


func step_inward():
	state_machine.set_current_state(on_anomation_state)
	if is_cursor_inside_area:
		_play_failure_animation()
		_update_score(score_fail_value)
	else:
		_play_success_animation()
		nb_layer -= 1


func _play_failure_animation():
	var tween :Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(container, "scale", container.scale * 0.9, 0.2)
	tween.parallel().tween_property(cursor, "scale", cursor.scale * 0.9, 0.2)
	tween.play()
	
	await tween.finished
	
	tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(container, "scale", container.scale / 0.9, 0.2)
	tween.parallel().tween_property(cursor, "scale", cursor.scale / 0.9, 0.2)
	tween.play()
	
	await tween.finished
	
	state_machine.set_current_state(default_state)


func _play_success_animation():
	var tween :Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(container, "scale", container.scale * 0.7, 0.3)
	tween.parallel().tween_property(cursor, "scale", cursor.scale * 0.7, 0.3)
	tween.play()
	
	await tween.finished
	
	state_machine.set_current_state(default_state)


func _update_score(value :float):
	score += value
	if score < 0:
		score = 0
	if score > score_max:
		score = score_max


func _move_cursor() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	cursor.look_at(mouse_position)


func modulate_color(score_ratio :float):
	print(score_ratio)
	timebar.modulate = gradient.gradient.sample(score_ratio)


func spawn_bars(parent :Node2D) -> void:
	var indices := []
	while indices.size() < nb_bar_spawn:
		var rnd := randi_range(0, 14)
		if not indices.has(rnd):
			indices.append(rnd)
	
	for i in range(15):
		if indices.has(i):
			var obj = wave_part_scene.instantiate()
			parent.add_child(obj)
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
	if cursor_area.has_overlapping_areas():
		return
	print("exited")
	colliding_bar = null
	is_cursor_inside_area = false
