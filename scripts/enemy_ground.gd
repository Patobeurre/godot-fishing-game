extends Enemy

# States
@onready var default_state : StateMachineState = $DefaultState
@onready var follow_state : StateMachineState = $FollowState
@onready var attack_state : StateMachineState = $AttackState


func _physics_process(delta):
	state_machine.current_state.on_physics_process(delta)
	
	var distance_to_target = global_position.distance_to(target.global_position)
	attack_state.is_target_detected = (distance_to_target < attack_range)
	
	if attack_state.is_current_state():
		if not attack_state.is_attacking:
			state_machine.set_current_state(follow_state)
	elif attack_state.is_target_detected:
		state_machine.set_current_state(attack_state)
	
	if default_state.is_current_state():
		if global_position.distance_to(target.global_position) < visibility_range:
			state_machine.set_current_state(follow_state)
	


@onready var head := $enemy_ground/Icosphere/StaticBody3D
@onready var body := $enemy_ground/Cube/StaticBody3D

@onready var attack_mesh := $enemy_ground/Icosphere
@onready var attack_area := $enemy_ground/Icosphere/Area3D

func _ready():
	head.headshot.connect(damage)
	body.bodyshot.connect(damage)
	attack_area.body_entered.connect(attack_state.on_attack_area_body_entered)
	attack_area.monitorable = false
	attack_area.monitoring = false
	state_machine.set_current_state(default_state)

