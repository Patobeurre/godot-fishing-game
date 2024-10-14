extends Node3D
class_name Skyscraper


@onready var skyscraper_floor :PackedScene= preload("res://objects/Structures/skyscraper_floor.tscn")

@export var max_size :int = 5
@export var starting_day = 0

var floors :Array[SkyscraperFloor] = []


func _ready() -> void:
	instantiate_new_floor()
	TimeManager.new_day.connect(on_new_day)


func update() -> void:
	var current_day = TimeManager.time_stats.day_count
	if starting_day > current_day:
		return
	for i in range(current_day - starting_day):
		progress_construction()


func progress_construction() -> void:
	if floors.is_empty():
		return
	
	for _floor in floors:
		_floor.increment_state()
	
	if floors.size() >= max_size:
		return 
	
	var last_floor = floors.back()
	if last_floor.is_completed():
		instantiate_new_floor()


func instantiate_new_floor():
	var floor_scene = skyscraper_floor.instantiate() as SkyscraperFloor
	add_child(floor_scene)
	floor_scene.position.y += floors.size()
	floors.append(floor_scene)


func on_new_day(day_count :int) -> void:
	if day_count >= starting_day:
		progress_construction()
