extends Node2D


@export var waiting_time_before :float = 2.0
@export var waiting_time_after :float = 2.0
@export var animation_speed :float = 2.0

@onready var spike_sprite := $Mask/SpikeSprite
@onready var timer := $Timer
@onready var animation_player := $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_spike()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move_spike() -> void:
	animation_player.play("move_spike")
