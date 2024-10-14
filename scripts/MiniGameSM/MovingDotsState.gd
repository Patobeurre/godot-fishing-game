extends StateMachineState


@onready var timer :Timer = $Timer
@onready var bar_scene :PackedScene = preload("res://sprites/fishing_game_dot.tscn")
var bars :Array = []

var controller = null

var mouse_sensitivity = 500
var min_bar_pos
var max_bar_pos
var bar_offset = 10
var dot_initial_offset = 200

var max_score :float = 100.0
var nb_bar_to_spawn :int = 3
var bar_move_interval :float = 1.5
var dot_speed :float = 100
var decrease_rate :float = 20.0
var miss_decrease_score :float = 20.0

var score :float
var input_mouse :Vector2 = Vector2.ZERO
var bar_counter :int
var is_win = false


# Called when the state machine enters this state.
func on_enter():
	controller = get_parent()
	score = max_score
	bar_counter = nb_bar_to_spawn
	min_bar_pos = controller.min_cursor_pos + bar_offset
	max_bar_pos = controller.max_cursor_pos - bar_offset
	init()


func init():
	controller.cursor.position.x = controller.bar_container.position.x
	score = max_score
	timer.start(bar_move_interval)


func _spawn_dot():
	var dot = bar_scene.instantiate()
	dot.modulate.a = 0
	controller.bars.add_child(dot)
	bars.append(dot)
	dot.position = controller.bar_container.global_position
	dot.position.x = randf_range(min_bar_pos, max_bar_pos)
	dot.position.y -= dot_initial_offset


# Called every frame when this state is active.
func on_process(delta):
	
	handle_mouse(delta)
	
	for dot in bars:
		dot.position.y += dot_speed * delta
		dot.modulate.a = 1 - ((controller.bar_container.global_position.y - dot.position.y) / dot_initial_offset)
	
	if Input.is_action_just_pressed("shoot"):
		if controller.is_cursor_inside_area:
			pass
		else:
			score -= miss_decrease_score
	else:
		score -= decrease_rate * delta
	


func _remove_dot():
	var areas = controller.cursor_area.get_overlapping_areas()


func handle_mouse(delta):
	var newX_pos = controller.cursor.global_position.x + input_mouse.x * mouse_sensitivity
	newX_pos = min(newX_pos, controller.max_cursor_pos)
	newX_pos = max(newX_pos, controller.min_cursor_pos)
	controller.cursor.global_position.x = newX_pos
	input_mouse = Vector2.ZERO


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity


# Called when the state machine exits this state.
func on_exit():
	pass


func _on_timer_timeout():
	_spawn_dot()
	timer.start()
