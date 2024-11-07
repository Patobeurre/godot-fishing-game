extends Resource
class_name BasketStats


@export var max_active_basket = 10

@export var baskets :Array[BasketRes] = []


func add_basket(basket_res :BasketRes):
	baskets.append(basket_res)


func get_available_baskets(type) -> Array[BasketRes]:
	return baskets.filter(func (b) :
		return b.is_available == true and \
			b.basket_type_res.type == type)


func get_registered_baskets() -> Array[BasketRes]:
	return baskets.filter(func (b) :
		return b.is_registered == true)


func recheck_available_baskets():
	for basket in baskets:
		if not basket.is_available and not basket.is_registered:
			basket.is_available = true
