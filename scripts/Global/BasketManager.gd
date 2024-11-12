extends Node


var basket_stats :BasketStats


func _ready() -> void:
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)


func add_new_basket(basket_type :BasketTypeRes):
	var basket_res = BasketRes.new()
	basket_res.basket_type_res = basket_type
	basket_stats.add_basket(basket_res)
	SignalBus.basket_added.emit(basket_res)


func pick_available_basket(type :BasketTypeRes.EBasketType):
	var picked_basket = basket_stats.get_available_baskets(type).pick_random()
	return picked_basket


func register(basket :BasketRes):
	if not basket_stats.baskets.has(basket):
		return
	basket.set_registered(true)
	SignalBus.save_requested.emit()


func unregister(basket :BasketRes):
	var idx = basket_stats.baskets.find(basket)
	if idx < 0: 
		print("basket not found")
		return
	basket.clear_catchables()
	basket.set_registered(false)
	basket.set_available(true)
	SignalBus.save_requested.emit()


func has_available_baskets(type :BasketTypeRes.EBasketType) -> bool:
	return not basket_stats.get_available_baskets(type).is_empty()


func count_available_basket_type(type :BasketTypeRes.EBasketType) -> int:
	return basket_stats.get_available_baskets(type).size()


func count_basket_type(type :BasketTypeRes.EBasketType) -> int:
	return basket_stats.count_basket_type(type)


func get_basket_types() -> Array[BasketTypeRes.EBasketType]:
	return basket_stats.get_basket_types()


func _instantiate_registered_baskets():
	for res :BasketRes in basket_stats.get_registered_baskets():
		var basket_node = res.basket_type_res.scene.instantiate()
		add_child(basket_node)
		basket_node.load_from_resource(res)


func _on_savegame_loaded():
	basket_stats.recheck_available_baskets()
	_instantiate_registered_baskets()


func set_stats(stats :BasketStats):
	basket_stats = stats
