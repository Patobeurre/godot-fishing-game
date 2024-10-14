extends StateMachineState


@export var parent :CharacterBody3D
@export var bullet_speed :float = 2.0
@export var nb_bullet :int = 1
@export var bullet_cadency :float = 0.5
@export var attack_cd :float = 2

@onready var cd_timer :Timer = $AttackCD
@onready var bullet_scene :PackedScene = preload("res://objects/enemies/bullet.tscn")

var spawner :Node3D
var target :Node3D

var is_attacking : bool = false


# Called when the state machine enters this state.
func on_enter():
	spawner = parent.spawner
	target = parent.target
	if parent.animation != null:
		parent.animation.play("Armature_001Action_002")


func spawn_projectile():
	var projectile = bullet_scene.instantiate()
	projectile.global_position = spawner.global_position
	var direction = spawner.global_position.direction_to(target.global_position)
	projectile.linear_velocity = direction * bullet_speed
	add_child(projectile)

# Called every frame when this state is active.
func on_process(delta):
	pass
	


# Called every physics frame when this state is active.
func on_physics_process(delta):
	
	if not is_attacking:
		is_attacking = true
		var look_direction = target.position
		look_direction.y = parent.position.y
		parent.look_at(look_direction, Vector3.UP, true)
		cd_timer.start(attack_cd)
		spawn_projectile()


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	if parent.animation != null:
		parent.animation.play_backwards("Armature_001Action_002")


func _on_attack_cd_timeout():
	is_attacking = false
