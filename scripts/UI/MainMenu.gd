extends MainUI


func _on_activate():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_movements.emit(false)
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_hud.emit(false)

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_movements.emit(true)
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_hud.emit(true)


func _on_btn_quit_pressed() -> void:
	get_tree().quit()

func _on_btn_play_button_down() -> void:
	SignalBus.title_menu_play.emit()
