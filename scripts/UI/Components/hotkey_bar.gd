extends CenterContainer


@onready var amount_label = $MarginContainer/HBoxContainer/Panel/TextureRect2/AmountLabel


func _ready() -> void:
	BasketManager.basket_added.connect(_on_basket_added)


func _on_basket_added(basket :BasketRes):
	pass
