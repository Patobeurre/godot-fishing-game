extends StateMachineState


@onready var timer :Timer = $Timer
@onready var bar_scene :PackedScene = preload("res://sprites/fishing_game_bar.tscn")
@onready var audio_player :AudioStreamPlayer = $AudioStreamPlayer

var bar = null

var controller = null

var mouse_sensitivity = 500
var min_bar_pos
var max_bar_pos
var bar_offset = 55

var stats :MiniGameRes

var score :float
var input_mouse :Vector2 = Vector2.ZERO
var is_started = false
var is_win = false


# Called when the state machine enters this state.
func on_enter():
	controller = get_parent()
	init()


func init():
	stats = CatchableRes.get_minigame_difficulty(controller.catchable.rarity)
	min_bar_pos = controller.min_cursor_pos + bar_offset
	max_bar_pos = controller.max_cursor_pos - bar_offset
	score = stats.max_score / 2
	bar = bar_scene.instantiate()
	controller.bars.add_child(bar)
	bar.position = controller.bar_container.global_position
	move_bar()
	controller.cursor.position.x = controller.bar_container.position.x
	timer.start(stats.bar_move_interval)
	audio_player.stream_paused = true
	audio_player.play()
	is_started = true


# Called every frame when this state is active.
func on_process(delta):
	if not is_started: return
	
	handle_mouse(delta)
	
	check_win()
	
	if Input.is_action_pressed("shoot"):
		if controller.is_cursor_inside_area:
			score += stats.acceleration_rate * delta
			audio_player.stream_paused = false
		else:
			score -= stats.miss_deceleration_rate * delta
			audio_player.stream_paused = true
	else:
		score -= stats.deceleration_rate * delta
		audio_player.stream_paused = true
	
	bar.modulate.a = score / stats.max_score


func end_game():
	audio_player.stop()
	is_started = false
	bar.queue_free()
	timer.stop()
	SignalBus.end_minigame.emit(is_win)


func move_bar():
	var bar_new_pos = bar.global_position
	bar_new_pos.x = get_random_step()
	var tween := get_tree().create_tween().bind_node(bar).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(bar, "global_position", bar_new_pos, randf_range(0.2, 0.8))
	tween.play()

func get_random_step():
	return randi_range(min_bar_pos, max_bar_pos)


func check_win():
	if score >= stats.max_score:
		is_win = true
		end_game()
	if score <= 0:
		is_win = false
		end_game()


func handle_mouse(delta):
	var newX_pos = controller.cursor.global_position.x + input_mouse.x * mouse_sensitivity
	newX_pos = min(newX_pos, controller.max_cursor_pos)
	newX_pos = max(newX_pos, controller.min_cursor_pos)
	controller.cursor.global_position.x = newX_pos
	input_mouse = Vector2.ZERO


func on_input(event):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass



# Called when the state machine exits this state.
func on_exit():
	pass


func _on_timer_timeout():
	move_bar()
	timer.start()
