extends StateMachineState


@onready var dot_scene :PackedScene = preload("res://sprites/fishing_game_dot.tscn")
var dots :Array = []

var controller = null
var stats :MiniGameRes

var mouse_sensitivity = 500
var min_bar_pos
var max_bar_pos
var bar_offset = 10

var score :float
var input_mouse :Vector2 = Vector2.ZERO
var bar_counter :int
var is_win = false


# Called when the state machine enters this state.
func on_enter():
	controller = get_parent()
	stats = CatchableRes.get_minigame_difficulty(controller.catchable.rarity)
	bar_counter = stats.nb_bar_to_spawn
	min_bar_pos = controller.min_cursor_pos + bar_offset
	max_bar_pos = controller.max_cursor_pos - bar_offset
	init()


func init():
	controller.cursor.position.x = controller.bar_container.position.x
	score = stats.max_score
	_spawn_dots()


func _spawn_dots():
	dots = []
	for i in range(stats.nb_bar_to_spawn):
		var dot = dot_scene.instantiate()
		dots.append(dot)
		controller.bars.add_child(dot)
		dot.position = controller.bar_container.global_position
		dot.position.x = randf_range(min_bar_pos, max_bar_pos)
		dot.init(stats.dot_speed, stats.dot_speed_offset)


# Called every frame when this state is active.
func on_process(delta :float):
	
	check_win()
	
	handle_mouse(delta)
	
	if Input.is_action_just_pressed("shoot"):
		if controller.is_cursor_inside_area:
			score += stats.acceleration_rate
		else:
			score -= stats.miss_deceleration_rate
	else:
		score -= stats.deceleration_rate * delta
	
	_move_dots(delta)


func end_game():
	SignalBus.end_minigame.emit(is_win)


func check_win():
	if score >= stats.max_score:
		is_win = true
		end_game()
	if score <= 0:
		is_win = false
		end_game()


func _move_dots(delta :float) -> void:
	for dot in dots:
		var dot_new_pos_x = dot.global_position.x + (dot.speed * dot.direction * delta)
		if dot_new_pos_x > max_bar_pos:
			dot_new_pos_x = max_bar_pos
			dot.direction = -dot.direction
		if dot_new_pos_x < min_bar_pos:
			dot_new_pos_x = min_bar_pos
			dot.direction = -dot.direction
		dot.global_position.x = dot_new_pos_x
		
		print(score)
		dot.modulate.a = score / stats.max_score


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


# Called when the state machine exits this state.
func on_exit():
	pass
