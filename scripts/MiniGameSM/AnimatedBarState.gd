extends StateMachineState


@onready var audio_player :AudioStreamPlayer = $AudioStreamPlayer
@onready var bar_scene :PackedScene = preload("res://objects/UI/minigame_bar.tscn")
var bar :MinigameBar = null

var controller = null
var stats :MiniGameRes

var mouse_sensitivity = 500
var min_bar_pos
var max_bar_pos
var bar_offset = 55

var score :float
var input_mouse :Vector2 = Vector2.ZERO
var is_win = false


# Called when the state machine enters this state.
func on_enter():
	controller = get_parent()
	stats = CatchableRes.get_minigame_difficulty(controller.catchable.rarity)
	score = stats.max_score / 2
	controller.cursor.position.x = controller.bar_container.position.x
	spawn_bar()


# Called every frame when this state is active.
func on_process(delta):
	
	print(input_mouse)
	handle_mouse(delta)
	
	if check_win(): return
	
	if controller.is_cursor_inside_area:
		score += stats.acceleration_rate * delta
		audio_player.stream_paused = false
	else:
		score -= stats.miss_deceleration_rate * delta
		audio_player.stream_paused = true
	
	bar.modulate_color(score / stats.max_score)


func spawn_bar():
	bar = bar_scene.instantiate()
	controller.bars.add_child(bar)
	bar.init(controller.catchable.minigame_res, \
		controller.bar_container.global_position, \
		controller.bar_container.global_position.x - controller.min_cursor_pos)


func check_win():
	if score >= stats.max_score:
		is_win = true
		end_game()
	if score <= 0:
		is_win = false
		end_game()


func end_game():
	SignalBus.end_minigame.emit(is_win)


func handle_mouse(delta :float):
	var newX_pos = controller.cursor.global_position.x + input_mouse.x * mouse_sensitivity
	newX_pos = min(newX_pos, controller.max_cursor_pos)
	newX_pos = max(newX_pos, controller.min_cursor_pos)
	controller.cursor.global_position.x = newX_pos
	input_mouse = Vector2.ZERO


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass
