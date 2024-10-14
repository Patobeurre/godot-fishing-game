extends Node3D

@onready var mesh = $rocks_merged
@onready var static_body :ExplodingFishingArea = $rocks_merged/StaticBody3D
@onready var explosion_particule = $ExplosionBlast


func _ready():
	static_body.perform_interaction.connect(explode_animation)


func explode_animation():
	Audio.play("sounds/explosion_big_fireball_001_89751.mp3, \
				sounds/explosion_big_fireball_002_89752.mp3")
	explosion_particule.emit_particules()
	mesh.queue_free()
