extends MainUI


@onready var hand = $CenterContainer/ClockHand
@onready var hand_current_time = $CenterContainer/ClockHand2

@onready var state_machine := $FiniteStateMachine
@onready var default_state = $DefaultState
@onready var dragging_state = $DraggingState
@onready var passing_time_state = $PassingTimeState

var min_rotation :float
var max_rotation :float
var max_anim_duration :float = 5.0
var is_mouse_in_area :bool = false


func _on_ready():
	hand.position = get_viewport_rect().size / 2
	hand_current_time.position = get_viewport_rect().size / 2


func init_clock():
	var angle = (TimeManager.get_time_ratio() * 360) + 90
	min_rotation = angle + 1
	max_rotation = angle + 359
	hand.rotation_degrees = min_rotation
	hand_current_time.rotation_degrees = angle
	state_machine.set_current_state(default_state)


func _on_process(delta):
	if passing_time_state.is_current_state():
		return
	
	if Input.is_action_just_pressed("ui_cancel") and \
		not is_preventing_input:
		UiManager.close(unique_id)

func animate_time_passing():
	var anim_duration = (hand.rotation_degrees - min_rotation) / 360
	anim_duration *= max_anim_duration
	
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(hand_current_time, "rotation_degrees", hand.rotation_degrees, anim_duration)
	tween.play()
	
	await tween.finished
	
	var new_time = fmod((hand.rotation_degrees) - 90, 360) / 360 * 2400
	print(new_time)
	TimeManager.set_time_of_day(new_time)
	UiManager.close(unique_id)


func _on_input(event):
	if Input.is_action_just_released("ui_cancel"):
		is_preventing_input = false


func start_dragging():
	if is_mouse_in_area:
		state_machine.set_current_state(dragging_state)


func stop_dragging():
	state_machine.set_current_state(default_state)


func drag_to_new_rotation():
	var mouse_pos = get_viewport().get_mouse_position()
	hand.look_at(mouse_pos)
	print(hand.rotation_degrees)
	if hand.rotation_degrees < min_rotation:
		hand.rotation_degrees = min_rotation
	if hand.rotation_degrees > max_rotation:
		hand.rotation_degrees = max_rotation


func end_rotation():
	pass


func _on_area_2d_mouse_entered() -> void:
	is_mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	is_mouse_in_area = false


func _on_activate():
	TimeManager.stop()
	init_clock()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)
	SignalBus.enable_player_hud.emit(false)

func _on_deactivate():
	TimeManager.resume()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)
	SignalBus.enable_player_hud.emit(true)


func _on_btn_dusk_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.DUSK))


func _on_btn_day_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.DAY))


func _on_btn_dawn_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.DAWN))


func _on_btn_night_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.NIGHT))


func _on_button_pressed() -> void:
	state_machine.set_current_state(passing_time_state)
	animate_time_passing()


func _on_click_outside_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_released("mouse_left"):
		#UiManager.close(unique_id)
		pass
