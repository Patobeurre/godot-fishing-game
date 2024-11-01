extends WorldEnvironment

@export_range(0, 360, 0.1) var skyRotation : float = 0.0
@export var sunLightOffset :float = 30
@export var moonLightOffset :float = 15

@onready var sunMoonParent = $"Sun&Moon"
@onready var sunNode = $"Sun&Moon/Sun"
@onready var moonNode = $"Sun&Moon/Moon"

@onready var sunLight = $"Sun&Moon/Sun/SunLight"
@onready var moonLight = $"Sun&Moon/Moon/MoonLight"

var sunPosition : Vector3 = Vector3.ZERO
var moonPosition : Vector3 = Vector3.ZERO


func _ready():
	SignalBus.player_pos_update.connect(updatePosition)
	SignalBus.hide_sun.connect(_on_hide_sun)
	TimeManager.new_day.connect(on_new_day)
	#skyRotation -= 10


func updateLightnings():
	sunPosition = sunNode.global_position
	moonPosition = moonNode.global_position
	
	sunLight.visible = (sunPosition.y > -sunLightOffset)
	moonLight.visible = (moonPosition.y > -moonLightOffset)
	
	var distance = sunMoonParent.global_position.distance_to(sunNode.global_position)
	
	sunLight.light_energy = (sunPosition.y + sunLightOffset) / (distance*2)
	moonLight.light_energy = (moonPosition.y + moonLightOffset) / (distance*2)

func updateRotation():
	var hourMapped = remap(TimeManager.time_stats.time_of_day, 0.0, 2400.0, 0.0, 1.0)
	sunMoonParent.rotation_degrees.y = skyRotation
	sunMoonParent.rotation_degrees.x = hourMapped * 360.0

func updatePosition(target_pos :Vector3):
	sunMoonParent.global_position = Vector3(target_pos.x, 0, target_pos.z)


func _on_hide_sun(enabled :bool):
	sunNode.visible = not enabled


func _physics_process(delta):
	updateRotation()
	updateLightnings()


func on_new_day(day_count :int):
	skyRotation -= 10
