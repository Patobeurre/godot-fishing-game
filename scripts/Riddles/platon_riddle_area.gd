extends CatchableArea

@export var key_tetra :CatchableRes
@export var key_cube :CatchableRes
@export var key_sphere :CatchableRes

@export var offset :float = 3

@onready var tetra = $TetrahedraFish
@onready var cube = $CubeFish
@onready var sphere = $BombFish


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_save_game_loaded)


func prepare():
	_try_place_catchable()
	FishingManager.cancel()


func _try_place_catchable():
	var current_lure = FishingManager.fishing_stats.current_lure
	if current_lure == key_tetra:
		ProgressVariables.update_progress_variable("tetra_placed", true)
		_place_key(tetra)
	elif current_lure == key_cube:
		ProgressVariables.update_progress_variable("cube_placed", true)
		_place_key(cube)
	elif current_lure == key_sphere:
		ProgressVariables.update_progress_variable("sphere_placed", true)
		_place_key(sphere)


func _place_key(key :Node3D) -> void:	
	var target_pos = key.position
	key.position.x += offset
	
	key.visible = true
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(key, "position", target_pos, 1)
	tween.play()
	
	await tween.finished


func _on_save_game_loaded():
	if ProgressVariables.check_variable("tetra_placed", true):
		tetra.visible = true
	if ProgressVariables.check_variable("cube_placed", true):
		cube.visible = true
	if ProgressVariables.check_variable("sphere_placed", true):
		sphere.visible = true


func disable_collision():
	if self_node is Area3D:
		self_node.monitoring = false
		self_node.monitorable = false
	elif self_node is StaticBody3D:
		$CollisionShape3D.set_deferred("disabled", true)
