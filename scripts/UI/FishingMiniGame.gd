extends MainUI


@onready var cursor :Sprite2D = $AspectRatioContainer/FishingGameCursor
@onready var bar :Sprite2D = $AspectRatioContainer/FishingGameBar
@onready var timer :Timer = $AspectRatioContainer/Timer
@onready var left_border = $AspectRatioContainer/LeftBoundary
@onready var right_border = $AspectRatioContainer/RightBoundary

@onready var minigame_sm = $FiniteStateMachine
@onready var default_state = $DefaultState
@onready var moving_bar_state = $MovingBarState


var mouse_sensitivity = 500
var min_cursor_pos
var max_cursor_pos
var min_bar_pos
var max_bar_pos

var max_score :float = 100.0
var acceleration_rate :float = 30.0
var deceleration_rate :float = 20.0
var bar_move_interval :float = 1.5
var bar_speed :float = 5.0

var score :float
var input_mouse :Vector2 = Vector2.ZERO
var is_inside_area :bool = false
var is_started = false
var is_win = false


func _on_activate():
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)
	init(FishingManager.picked_catchable)

func _on_deactivate():
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)


func init(catchable :CatchableRes):
	min_cursor_pos = left_border.global_position.x
	max_cursor_pos = right_border.global_position.x
	min_bar_pos = 517
	max_bar_pos = 763
	score = max_score / 2
	timer.start(bar_move_interval)
	is_started = true


func end_game():
	is_started = false
	timer.stop()
	SignalBus.end_minigame.emit(is_win)


func _on_process(delta):
	if not is_started: return
	
	handle_mouse(delta)
	
	check_win()
	
	if Input.is_action_pressed("shoot"):
		if is_inside_area:
			score += acceleration_rate * delta
		else:
			score -= deceleration_rate * 2 * delta
	else:
		score -= deceleration_rate * delta
	
	bar.modulate.a = score / max_score


func move_bar():
	var bar_new_pos = bar.global_position
	bar_new_pos.x = get_random_step()
	var tween := get_tree().create_tween().bind_node(bar).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(bar, "global_position", bar_new_pos, randf_range(0.2, 0.8))
	tween.play()

func get_random_step():
	return randi_range(min_bar_pos, max_bar_pos)


func check_win():
	if score >= max_score:
		is_win = true
		end_game()
	if score <= 0:
		is_win = false
		end_game()


func handle_mouse(delta):
	var newX_pos = cursor.global_position.x + input_mouse.x * mouse_sensitivity
	newX_pos = min(newX_pos, max_cursor_pos)
	newX_pos = max(newX_pos, min_cursor_pos)
	cursor.global_position.x = newX_pos
	input_mouse = Vector2.ZERO


func _on_input(event):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity


func _on_area_2d_area_entered(area):
	is_inside_area = true

func _on_area_2d_area_exited(area):
	is_inside_area = false

func _on_timer_timeout():
	move_bar()
	timer.start()
