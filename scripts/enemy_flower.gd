extends Enemy

# States
@onready var default_state : StateMachineState = $DefaultState
@onready var attack_state : StateMachineState = $AttackState

@onready var spawner :Node3D = $BulletSpawner

@onready var head := $BaseMesh/Armature_001/Skeleton3D/HeadBone/StaticBody3D
@onready var body1 := $BaseMesh/Armature_001/Skeleton3D/Body1/StaticBody3D
@onready var body2 := $BaseMesh/Armature_001/Skeleton3D/Body2/StaticBody3D
@onready var body3 := $BaseMesh/Armature_001/Skeleton3D/Body3/StaticBody3D
@onready var body4 := $BaseMesh/Armature_001/Skeleton3D/Body4/StaticBody3D
@onready var body5 := $BaseMesh/Armature_001/Skeleton3D/Body5/StaticBody3D

func _ready():
	head.headshot.connect(damage)
	body1.bodyshot.connect(damage)
	body2.bodyshot.connect(damage)
	body3.bodyshot.connect(damage)
	body4.bodyshot.connect(damage)
	body5.bodyshot.connect(damage)
	state_machine.set_current_state(default_state)
	

func _physics_process(delta):
	state_machine.current_state.on_physics_process(delta)
	
	if global_position.distance_to(target.global_position) < attack_range:
		if not attack_state.is_current_state():
			state_machine.set_current_state(attack_state)
	else:
		state_machine.set_current_state(default_state)

