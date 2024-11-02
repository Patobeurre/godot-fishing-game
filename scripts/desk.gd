extends Node3D


@onready var desk_body = $Cube_022/StaticBody3D
@onready var drawer_body = $Cube_128/StaticBody3D
@onready var drawer_mesh = $Cube_128

var drawer_pos_offset :float = 0.4
var is_drawer_opened :bool = false
var is_interacting :bool = false


func _ready() -> void:
	desk_body.interact_performed.connect(interact_desk)
	drawer_body.interact_performed.connect(interact_drawer)


func interact_desk():
	UiManager.open("DocumentsCollection")


func interact_drawer():
	if is_interacting: return
	
	is_interacting = true
	var target_pos :Vector3 = drawer_mesh.position
	
	if is_drawer_opened:
		target_pos.x += drawer_pos_offset
		drawer_body.interact_text = "Open"
	else:
		target_pos.x -= drawer_pos_offset
		drawer_body.interact_text = "Close"
	
	var tween := get_tree().create_tween().bind_node(drawer_mesh).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(drawer_mesh, "position", target_pos, 0.5)
	tween.play()
	
	await tween.finished
	
	is_drawer_opened = not is_drawer_opened
	is_interacting = false
