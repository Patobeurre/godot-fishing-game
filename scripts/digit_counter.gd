extends Node3D


@export var value: int = 0
@export var SPACING: int = 8
@export var SCALE_SIZE: float = 1. 
@export var digits_meshes: Array[PackedScene] = []

var value_digits: Array[PackedScene] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	update_value(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _clear_digits():
	for n in get_children():
		remove_child(n)
		n.queue_free()

func update_value(val: int):
	if val == value:
		return
	value = val
	
	_clear_digits()
	
	var value_str = str(val)
	value_digits.clear()
	for c in value_str:
		value_digits.push_back(digits_meshes[int(c)])
		
	draw_digits()

func draw_digits():
	var positionX := -((value_digits.size()-1)*SPACING) / 2
	for digit_obj in value_digits:
		var obj = digit_obj.instantiate()
		obj.scale *= Vector3(SCALE_SIZE,SCALE_SIZE,SCALE_SIZE)
		obj.position.x = positionX
		positionX += SPACING
		add_child(obj)
