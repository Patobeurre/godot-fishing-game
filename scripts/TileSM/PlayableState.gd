extends StateMachineState

@export var mesh: Node3D
@export var boundaries: Node3D
@export var counters: Node3D
@onready var base_surface: StandardMaterial3D = preload("res://materials/base_surface.tres")
@onready var outline_shader: Shader = preload("res://materials/outline.gdshader")

@export var TIME_PERIOD := 5.
var time := 0.

signal timer_changed(value)
signal timer_timeout

# Called when the state machine enters this state.
func on_enter():
	mesh.material_override = base_surface
	var outline = ShaderMaterial.new()
	outline.shader = outline_shader
	mesh.material_overlay = outline
	
	_activate_boundaries(true)
	
	time = TIME_PERIOD


func _activate_boundaries(activate: bool):
	boundaries.visible = activate
	var coll_bounds: Array = boundaries.find_children("", "CollisionShape3D", true)
	for coll in coll_bounds:
		coll.set_deferred("disabled", not activate)

# Called every frame when this state is active.
func on_process(delta):
	if time > 0:
		time -= delta
		timer_changed.emit(time)
	
	timer_timeout.emit()


# Called every physics frame when this state is active.
func on_physics_process(delta):
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	_activate_boundaries(false)
	pass

