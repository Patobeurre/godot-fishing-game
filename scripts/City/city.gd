extends Node3D


@onready var skyscrapers :Node3D = $Skyscrapers

var city_stats :CityStats = CityStats.new()


func _ready() -> void:
	SignalBus.savegame_loaded.connect(update)


func update() -> void:
	for skyscraper in skyscrapers.get_children():
		skyscraper.starting_day += city_stats.starting_day
		skyscraper.update()


func set_stats(stats :CityStats) -> void:
	city_stats = stats
