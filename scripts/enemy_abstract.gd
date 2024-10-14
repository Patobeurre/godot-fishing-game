class_name Enemy extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_group("Properties")
@export var life : float = 10
@export var visibility_range :float = 10
@export var attack_range :float = 5

@onready var state_machine : FiniteStateMachine = $FiniteStateMachine

@onready var raycast_stairs = $StairSystem
@onready var raycast_stairs_fwd: RayCast3D = $StairSystem/RayCastFwd
@onready var raycast_stairs_down: RayCast3D = $StairSystem/RayCastDown
@onready var hit_debug = preload("res://sprites/hit_debug.tscn")

@onready var animation :AnimationPlayer = $BaseMesh/AnimationPlayer
@onready var nav : NavigationAgent3D = $NavigationAgent3D


@export_group("Behaviour")
@export var target : Node3D

var direction: Vector3 = Vector3.ZERO
var applied_velocity: Vector3 = Vector3.ZERO
var gravity_direction: Vector3 = Vector3.ZERO
var head_offset: Vector3 = Vector3.ZERO
var step_height_main: Vector3
var step_incremental_check_height: Vector3


@onready var heads := $BaseMesh
@onready var bodies := $BaseMesh


func _process(delta):
	if (life <= 0):
		queue_free()

func damage(amount):
	life -= amount
	print(life)

