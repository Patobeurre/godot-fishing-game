extends CatchableArea
class_name SharkArea


@onready var shark_dorsal = $RigidBody3D
@onready var orbit_center = $OrbitCenter
@onready var animation_player = $AnimationPlayer

@export var speed :float = 5.0

var body_entered :Node3D
var is_shark_orbiting :bool = false


func _ready():
	animation_player.play("emerge")


func _process(delta):
	if is_shark_orbiting:
		orbit_center.rotate(Vector3(0, 1, 0), deg_to_rad(10) * speed * delta)


func get_fish_table():
	if subFishingAreaEntered != null:
		return subFishingAreaEntered.get_fish_table()
		
	return fishTable


func prepare():
	if subFishingAreaEntered != null:
		subFishingAreaEntered.prepare()
		return
	
	FishingManager.pick_catchable(fishTable)
	_start_orbiting()


func _start_orbiting():
	orbit_center.global_position = body_entered.global_position
	shark_dorsal.reparent(orbit_center)
	var look_at_pos = body_entered.global_position
	look_at_pos.y = shark_dorsal.global_position.y
	shark_dorsal.look_at(look_at_pos)
	is_shark_orbiting = true


func _shark_sunk():
	var move_to :Vector3 = shark_dorsal.global_position
	move_to.y -= 1
	
	var tween = get_tree().create_tween().bind_node(shark_dorsal).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(shark_dorsal, "global_position", move_to, 0.5)
	tween.play()
	
	await tween.finished


func _shark_retreive_position():
	shark_dorsal.reparent(self)
	var look_at_pos = global_position
	look_at_pos.y = shark_dorsal.global_position.y
	shark_dorsal.look_at(look_at_pos)
	shark_dorsal.rotate_y(deg_to_rad(90))
		
	var tween = get_tree().create_tween().bind_node(shark_dorsal).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(shark_dorsal, "global_position", look_at_pos, 1)
	tween.play()
	
	await tween.finished


func perform():
	if subFishingAreaEntered != null:
		subFishingAreaEntered.perform()
		return
	
	if FishingManager.picked_catchable != null:
		FishingManager.start_mini_game(FishingManager.picked_catchable)


func on_finished(succeeded :bool):
	is_shark_orbiting = false
	
	if subFishingAreaEntered != null:
		subFishingAreaEntered.on_finished(succeeded)
		return
	
	if succeeded:
		if is_one_shot:
			_shark_sunk()
			disable_collision()
			
		FishingManager.add_lure(FishingManager.picked_catchable)
		SignalBus.bobber_has_catched.emit(FishingManager.picked_catchable)
	else:
		_shark_retreive_position()


func disable_collision():
	if self_node is Area3D:
		self_node.monitoring = false
		self_node.monitorable = false


func _on_body_entered(body: Node3D) -> void:
	body_entered = body


func _on_body_exited(body: Node3D) -> void:
	if is_shark_orbiting:
		is_shark_orbiting = false
		_shark_retreive_position()
