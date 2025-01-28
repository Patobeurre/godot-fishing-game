extends AudioStreamPlayer
class_name Frequency


@export var volume_curve :CurveTexture


func update_volume(point :float):
	print(volume_curve.curve.sample(point))
	volume_db = volume_curve.curve.sample(point)
