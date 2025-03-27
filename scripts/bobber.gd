extends RigidBody3D
class_name Bobber


@onready var lure_spawn :Node3D = $Node3D/LureSpawn
@onready var collision_fishing_area :CollisionShape3D = $Node3D/Area3D_fishing/CollisionShape3D
@onready var trigger_player_area :Area3D = $Node3D/Area3D_player
@onready var collision_shape :CollisionShape3D = $CollisionShape3D
@onready var mesh = $Node3D/bobber_merged
@onready var billboard = $Billboard
@onready var rope_point = $RopePoint
@onready var animation_player :AnimationPlayer = $AnimationPlayer

var local_collision_pos :Vector3 = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.bobber_has_catched.connect(on_bobber_has_catched)
	SignalBus.catching_started.connect(on_catching_started)
	set_attached_lure(FishingManager.get_current_lure())
	billboard.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func enable_player_area(enabled :bool):
	collision_fishing_area.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	trigger_player_area.set_deferred("monitorable", enabled)
	trigger_player_area.monitoring = enabled
	mesh.rotation.z = 0

func on_bobber_has_catched(catchable :CatchableRes):
	set_attached_lure(catchable)


func set_attached_lure(lure :CatchableRes):
	if lure == null: return
	if lure.scene == null: return
	
	for child in lure_spawn.get_children():
		lure_spawn.remove_child(child)
	
	var lureScene = lure.scene.instantiate()
	lure_spawn.add_child(lureScene)
	lureScene.global_position = lure_spawn.global_position


func get_rope_point() -> Vector3:
	return rope_point.global_position


func _on_area_3d_player_body_entered(body):
	SignalBus.bobber_return_to_player.emit()

func _integrate_forces(state):
	if state.get_contact_count() >= 1:
		local_collision_pos = state.get_contact_local_position(0)


func on_catching_started():
	Audio.play("sounds/FishEffectsComplete/cursor_select.wav")
	animation_player.play("billboard")


func _on_body_entered(body):
	var collision_position = to_global(local_collision_pos + get_position())
	$Node3D.look_at(collision_position)
	billboard.global_position = mesh.global_position
	billboard.global_rotation = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	gravity_scale = 0
	if body.has_method("get_fish_table"):
		#reparent(body)
		SignalBus.bobber_enter_fishing_area.emit(body as CatchableArea)
	else:
		SignalBus.bobber_collide_wall.emit()
