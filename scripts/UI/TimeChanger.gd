extends MainUI


func _on_ready():
	pass

func _on_process(delta):
	if Input.is_action_just_pressed("ui_cancel") and \
		not is_preventing_input:
		UiManager.close(unique_id)

func _on_input(event):
	if Input.is_action_just_released("ui_cancel"):
		is_preventing_input = false


func _on_activate():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)


func _on_btn_dusk_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.DUSK))


func _on_btn_day_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.DAY))


func _on_btn_dawn_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.DAWN))


func _on_btn_night_button_down():
	TimeManager.set_time_of_day(TimePeriod.to_value(TimePeriod.ETimePeriod.NIGHT))
