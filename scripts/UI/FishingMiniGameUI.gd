extends MainUI


@onready var scene_node = $MiniGameScene

@onready var default_minigame_scene :PackedScene = preload("res://scenes/UI/MiniGame/minigame_horizontal_bar.tscn")
@onready var wave_minigame_scene :PackedScene = preload("res://scenes/UI/MiniGame/minigame_waves.tscn")


var catchable :CatchableRes = null


func _on_ready():
	pass


func _on_input(event :InputEvent):
	if not is_activated: return
	
	if event.is_action_pressed("mouse_right"):
		UiManager.close(unique_id)
		SignalBus.end_minigame.emit(false)


func _remove_minigame_scene():
	for child in scene_node.get_children():
		scene_node.remove_child(child)


func load_minigame():
	catchable = FishingManager.picked_catchable
	
	_remove_minigame_scene()
	
	var minigame_scene = default_minigame_scene.instantiate()
	if catchable.minigame_res != null:
		minigame_scene = catchable.minigame_res.minigame_scene.instantiate()
	elif catchable.tags.has(catchable.ELureTag.FISH) and \
		not catchable.tags.has(catchable.ELureTag.MULTIPLE_LEGS):
		minigame_scene = wave_minigame_scene.instantiate()
	
	scene_node.add_child(minigame_scene)
	minigame_scene.init(catchable)


func _on_activate():
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)
	load_minigame()

func _on_deactivate():
	_remove_minigame_scene()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)
