extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func emit_particules():
	$InnerBlow.emitting = true
	$Sparks.emitting = true
	await get_tree().create_timer(0.05).timeout
	$Smoke.emitting = true
