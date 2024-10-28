extends StateMachineState


@onready var bar_scene :PackedScene = preload("res://sprites/fishing_game_bar.tscn")
var bar = null

var controller = null
var stats :MiniGameRes

var mouse_sensitivity = 500
var min_bar_pos
var max_bar_pos
var bar_offset = 55

var score :float
var bar_counter :int
var is_cursor_moving :bool = false
var is_click_performed :bool = false
var is_win = false


# Called when the state machine enters this state.
func on_enter():
	controller = get_parent()
	stats = CatchableRes.get_minigame_difficulty(controller.catchable.rarity)
	score = stats.max_score
	bar_counter = stats.nb_bar_to_spawn
	min_bar_pos = controller.min_cursor_pos + bar_offset
	max_bar_pos = controller.max_cursor_pos - bar_offset
	init()


func init():
	controller.cursor.position.x = controller.min_cursor_pos
	spawn_bar()


# Called every frame when this state is active.
func on_process(delta):
	if not is_cursor_moving:
		move_cursor()
	
	if check_game_finished(): return
	
	if Input.is_action_just_pressed("shoot") and \
		not is_click_performed:
		is_click_performed = true
		if controller.is_cursor_inside_area:
			bar.queue_free()
			bar_counter -= 1
			var current_score = (stats.max_score / stats.nb_bar_to_spawn) * (stats.nb_bar_to_spawn - bar_counter)
			SignalBus.minigame_score_updated.emit(current_score)
			if bar_counter > 0:
				spawn_bar()
			score = stats.max_score
			Audio.play(
				"sounds/FishEffectsComplete/zapsplat_sport_fishing_reel_wind_clicks_spool_002_78261.mp3, \
				sounds/FishEffectsComplete/zapsplat_sport_fishing_reel_wind_clicks_spool_short_hard_001_78262.mp3, \
				sounds/FishEffectsComplete/zapsplat_sport_fishing_reel_wind_clicks_spool_short_hard_002_78263.mp3"
			)
		else:
			score -= stats.miss_deceleration_rate
		is_click_performed = false
	
	score -= stats.deceleration_rate * delta
	
	bar.modulate.a = score / stats.max_score
	


func spawn_bar():
	bar = bar_scene.instantiate()
	controller.bars.add_child(bar)
	bar.position = controller.bar_container.global_position
	bar.position.x = randf_range(min_bar_pos, max_bar_pos)


func check_game_finished():
	if bar_counter <= 0:
		is_win = true
		end_game()
		return true
	elif score <= 0:
		is_win = false
		end_game()
		return true
	
	return false


func end_game():
	SignalBus.end_minigame.emit(is_win)


func move_cursor():
	is_cursor_moving = true
	var target_pos = _get_target_pos()
	print(controller.cursor.global_position)
	print(controller.max_cursor_pos)
	var tween := get_tree().create_tween().bind_node(controller.cursor).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(controller.cursor, "global_position", target_pos, 1 / stats.cursor_speed)
	tween.play()
	
	await tween.finished
	
	is_cursor_moving = false


func _get_target_pos() -> Vector2:
	var targetPos = controller.cursor.global_position
	if controller.cursor.global_position.x >= controller.max_cursor_pos - 1:
		targetPos.x = controller.min_cursor_pos
	else:
		targetPos.x = controller.max_cursor_pos
	return targetPos


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass
