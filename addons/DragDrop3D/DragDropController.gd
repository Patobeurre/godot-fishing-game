extends Node

@export var ray_length :float = 100

var draggables = []
var camera: Camera3D
var draging

func _ready():
	camera = get_tree().get_root().get_camera_3d()
	set_physics_process(false)

func register_draggable(node):
	draggables.append(node)
	node.drag_start.connect(_drag_start)
	node.drag_stop.connect(_drag_stop)
	
func _drag_start(node):
	draging = node
	set_physics_process(true)
	
func _drag_stop(node):
	set_physics_process(false)
	
func _physics_process(delta):
	var mouse = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse)
	var to = from + camera.project_ray_normal(mouse) * ray_length
	
	var cast = camera.get_world_3d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(
			from, to, draging.get_parent().get_collision_mask(), [draging.get_parent()]
			)
		)
	if not cast.is_empty():
		draging.on_hover(cast)
