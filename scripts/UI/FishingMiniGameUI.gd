extends MainUI


@onready var scene_node = $MiniGameScene

@onready var default_minigame_scene :PackedScene = preload("res://scenes/UI/MiniGame/minigame_horizontal_bar.tscn")


var catchable :CatchableRes = null


func _on_ready():
	pass

func _remove_minigame_scene():
	for child in scene_node.get_children():
		scene_node.remove_child(child)


func load_minigame():
	catchable = FishingManager.picked_catchable
	
	_remove_minigame_scene()
	
	var minigame_scene = default_minigame_scene.instantiate()
	if catchable.minigame_res != null:
		minigame_scene = catchable.minigame_res.minigame_scene.instantiate()
	
	scene_node.add_child(minigame_scene)
	minigame_scene.init(catchable)


func _on_activate():
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)
	load_minigame()

func _on_deactivate():
	_remove_minigame_scene()
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)
