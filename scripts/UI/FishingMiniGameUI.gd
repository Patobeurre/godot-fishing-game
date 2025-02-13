extends MainUI


@onready var scene = $MiniGameScene

@onready var round_wave_scene = preload("res://scenes/UI/minigame_waves.tscn")


var catchable :CatchableRes = null


func _on_ready():
	pass

func _remove_minigame_scene():
	for child in scene.get_children():
		scene.remove_child(child)


func load_minigame():
	catchable = FishingManager.picked_catchable
	
	_remove_minigame_scene()
	
	var minigame_scene :MiniGameWaves = round_wave_scene.instantiate()
	scene.add_child(minigame_scene)
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
