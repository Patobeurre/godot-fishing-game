extends Enemy

# States
@onready var default_state : StateMachineState = $DefaultState
@onready var follow_state : StateMachineState = $FollowState
@onready var attack_state : StateMachineState = $AttackState

@onready var spawner :Node3D = $BulletSpawner


func _physics_process(delta):
	state_machine.current_state.on_physics_process(delta)
	
	if default_state.is_current_state():
		if global_position.distance_to(target.global_position) < visibility_range:
			state_machine.set_current_state(follow_state)
	
	if global_position.distance_to(target.global_position) < attack_range:
		state_machine.set_current_state(attack_state)
		
	if attack_state.is_current_state() and global_position.distance_to(target.global_position) > attack_range:
		state_machine.set_current_state(follow_state)

@onready var head := $EnemyShoot/Head
@onready var body := $EnemyShoot/Body

func _ready():
	head.headshot.connect(damage)
	body.bodyshot.connect(damage)
	state_machine.set_current_state(default_state)

