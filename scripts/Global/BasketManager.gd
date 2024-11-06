extends Node


@onready var basket_scene = preload("res://objects/basket.tscn")

var basket_stats :BasketStats


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)


func register(basket :BasketRes):
	if basket_stats.baskets.has(basket):
		return
	basket_stats.baskets.append(basket)
	SignalBus.save_requested.emit()


func unregister(basket :BasketRes):
	var idx = basket_stats.baskets.find(basket)
	if idx < 0: 
		print("basket not found")
		return
	basket_stats.baskets.remove_at(idx)
	SignalBus.save_requested.emit()


func _on_savegame_loaded():
	for res :BasketRes in basket_stats.baskets:
		var basket_node = basket_scene.instantiate()
		add_child(basket_node)
		basket_node.load_from_resource(res)


func set_stats(stats :BasketStats):
	basket_stats = stats
