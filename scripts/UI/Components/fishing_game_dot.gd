extends Sprite2D


const directions = [-1,1]
var direction :int = 0
var speed :float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = directions[randi() % directions.size()]


func init(average_speed :float, speed_offset :float) -> void:
	speed = randf_range(average_speed - speed_offset, average_speed + speed_offset)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
