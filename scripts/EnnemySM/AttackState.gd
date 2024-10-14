extends StateMachineState


@export var parent :CharacterBody3D

@export_group("Attack")
@export var attack : float = 10
@export var attackCD : float = 1.0

@onready var attackTimer :Timer = $AttackCD

var attack_mesh
var attack_area :Area3D
var target

var initial_pos
var target_pos
var is_attacking :bool = false
var is_target_detected :bool = false

# Called when the state machine enters this state.
func on_enter():
	target = parent.target
	attack_mesh = parent.attack_mesh
	attack_area = parent.attack_area
	attack_area.set_deferred("monitorable", true)
	attack_area.set_deferred("monitoring", true)
	is_attacking = false


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if is_attacking:
		return
	if not is_target_detected:
		return
	
	is_attacking = true
	attack_area.set_deferred("monitorable", true)
	attack_area.set_deferred("monitoring", true)
	
	attackTimer.start(attackCD)
	
	initial_pos = attack_mesh.global_position
	target_pos = target.global_position
	target_pos.y = initial_pos.y
	
	var tween := get_tree().create_tween().bind_node(attack_mesh).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(attack_mesh, "global_position", target_pos, 0.3)
	tween.play()
	
	await tween.finished
	
	tween = get_tree().create_tween().bind_node(attack_mesh).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(attack_mesh, "global_position", initial_pos, 0.5)
	tween.play()
	
	await tween.finished
	
	is_attacking = false


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass


func on_attack_area_body_entered(body):
	if body.has_method("damage"):
			body.damage(attack)
			attack_area.set_deferred("monitorable", false)
			attack_area.set_deferred("monitoring", false)

