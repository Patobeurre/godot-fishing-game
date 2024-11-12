extends Panel


@onready var image := $Image
@onready var amount_label := $Image/AmountLabel
@onready var disable_panel := $Image/DisablePanel

@export var basket_res :BasketTypeRes


func _ready() -> void:
	SignalBus.basket_added.connect(_on_basket_added)
	SignalBus.basket_available.connect(_on_basket_available)
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)
	image.texture = basket_res.image


func _update_amount_label(amount :int):
	amount_label.text = "x" + str(amount)


func _update_enabled(enabled :bool):
	disable_panel.visible = (not enabled)


func _set_visible() -> void:
	visible = (BasketManager.count_basket_type(basket_res.type) > 0)


func _update():
	var nb_basket :int = BasketManager.count_available_basket_type(basket_res.type)
	_update_amount_label(nb_basket)
	_update_enabled(nb_basket > 0)
	_set_visible()


func _on_basket_added(res :BasketRes):
	if res.basket_type_res.type == basket_res.type:
		_update()


func _on_basket_available(available :bool):
	_update()


func _on_savegame_loaded():
	_update()
