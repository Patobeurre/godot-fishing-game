extends Node3D


@onready var counter1 = $Counter1
@onready var counter2 = $Counter2
@onready var counter3 = $Counter3
@onready var counter4 = $Counter4


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_all(value: int):
	counter1.update_value(value)
	counter2.update_value(value)
	counter3.update_value(value)
	counter4.update_value(value)
	visible = true
