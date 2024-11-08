extends Node3D


@onready var camera = $Camera3D
@onready var rotation_tmp_node = $RotationTmp

@onready var rune_a = $a
@onready var rune_b = $b
@onready var rune_c = $c
@onready var base_bottom = $base_bottom
@onready var rune_1 = $"1"
@onready var rune_2 = $"2"
@onready var rune_3 = $"3"
@onready var base_top = $base_top

var upper_runes :Array = [$"3", $b, $"2"]
var lower_runes :Array = [$a, $"1", $c]

var is_rotating :bool = false
var is_completed :bool = false


func _ready() -> void:
	_reparent_runes()


func _reparent_runes():
	for rune in lower_runes:
		rune.reparent(base_bottom)
	for rune in upper_runes:
		rune.reparent(base_top)


func _process(delta: float) -> void:
	if is_rotating: return
	
	if check_completion():
		return #is_completed = true
	
	if Input.is_action_just_released("mouse_left"):
		var intersection = raycast_at_mouse_position(512)
		if intersection.has("collider"):
			var collider = intersection["collider"]
			if collider.is_in_group("Base"):
				_reparent_runes()
				#collider.perform_rotation()
				animation_rotation_base(collider.get_parent())
				if collider.is_up:
					upper_runes = cycle(1, upper_runes)
				else:
					lower_runes = cycle(1, lower_runes)
			elif collider.is_in_group("Rune"):
				var idx :int = 0
				idx = upper_runes.find(collider.get_parent())
				if idx < 0:
					idx = lower_runes.find(collider.get_parent())
				
				animation_rotation_runes(idx)


func animation_rotation_base(base :Node3D):
	is_rotating = true
	
	var target_rotation = base.transform.basis.get_euler()
	print(target_rotation)
	target_rotation.y += deg_to_rad(60)
	print(target_rotation)
	
	var tween := get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(base, "basis", target_rotation, 0.5)
	tween.play()
	
	await tween.finished
	
	is_rotating = false


func animation_rotation_runes(idx :int):
	if is_rotating: return
	if idx != 1: return
	
	is_rotating = true
	
	upper_runes[idx].reparent(self)
	lower_runes[idx].reparent(self)
	
	upper_runes[idx].rotate(Vector3.FORWARD, deg_to_rad(180))
	lower_runes[idx].rotate(Vector3.FORWARD, deg_to_rad(180))
	
	var tmp = upper_runes[idx]
	upper_runes[idx] = lower_runes[idx]
	lower_runes[idx] = tmp
	
	upper_runes[idx].reparent(base_top)
	lower_runes[idx].reparent(base_bottom)
	
	is_rotating = false


func raycast_at_mouse_position(mask :int = 255):
	var mouse_pos = camera.get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var raycast_param :PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	raycast_param.from = ray_origin
	raycast_param.to = ray_end
	raycast_param.collision_mask = mask
	return get_world_3d().direct_space_state.intersect_ray(raycast_param)


func cycle(times : int, arr : Array) -> Array:
	times = posmod(times, arr.size())
	var temp_arr = []
	temp_arr.resize(arr.size())
	for i in arr.size():
		temp_arr[(i + times) % arr.size()] = arr[i]
	return temp_arr


func check_completion() -> bool:
	for i in range(upper_runes.size()):
		if upper_runes[i].find_child("StaticBody3D").matching_value != lower_runes[i].find_child("StaticBody3D").matching_value:
			return false
	return true





func test_tween(idx :int):
	if is_rotating: return
	if idx != 1: return
	
	is_rotating = true
	
	var target_rotation = rotation_tmp_node.global_rotation
	target_rotation.z += deg_to_rad(180)
	
	upper_runes[idx].reparent(rotation_tmp_node)
	lower_runes[idx].reparent(rotation_tmp_node)
	
	var tween := get_tree().create_tween().bind_node(rotation_tmp_node).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(rotation_tmp_node, "global_rotation", target_rotation, 0.5)
	tween.play()
	
	await tween.finished
	
	var tmp = upper_runes[idx]
	upper_runes[idx] = lower_runes[idx]
	lower_runes[idx] = tmp
	
	upper_runes[idx].reparent(base_top)
	lower_runes[idx].reparent(base_bottom)
	
	is_rotating = false
