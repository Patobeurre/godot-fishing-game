extends Node3D


@export var center_rotation :Node3D = null
@export var animation_duration :float = 3.0


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	TimeManager.rotation_changed.connect(_on_rotation_changed)


func _on_rotation_changed(angle :float) -> void:
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(center_rotation, "rotation_degrees", Vector3(0,angle,0), animation_duration)
	tween.play()


func _on_savegame_loaded():
	center_rotation.rotate_y(deg_to_rad(TimeManager.time_stats.rotation))
