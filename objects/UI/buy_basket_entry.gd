extends PanelContainer


@onready var image = $MarginContainer/HBoxContainer/ImageTexture
@onready var name_label = $MarginContainer/HBoxContainer/VBoxContainer/NameLabel
@onready var description_label = $MarginContainer/HBoxContainer/VBoxContainer/DescriptionLabel
@onready var quantity_label = $MarginContainer/HBoxContainer/QuantityPosessedLabel
@onready var buy_btn = $MarginContainer/HBoxContainer/MarginContainer/BtnBuy
@onready var disabled_panel = $DisabledPanel


var basket_res :BasketTypeRes = null

signal btn_buy_basket_pressed(BasketTypeRes)


func _ready() -> void:
	SignalBus.money_changed.connect(_on_money_changed)


func init(basket :BasketTypeRes):
	basket_res = basket
	_update()


func _update():
	image.texture = basket_res.image
	name_label.text = tr(basket_res.name)
	description_label.text = tr(basket_res.description)
	_update_quantity_label()
	buy_btn.text = str(basket_res.price)
	buy_btn.icon = preload("res://sprites/coins.png")
	_update_buy_btn()


func _update_quantity_label():
	quantity_label.text = "X " + str(BasketManager.count_basket_type(basket_res.type))

func _update_buy_btn() -> void:
	buy_btn.disabled = FishingManager.fishing_stats.money < basket_res.price


func _on_btn_buy_pressed() -> void:
	btn_buy_basket_pressed.emit(basket_res)


func _on_money_changed(money :int):
	_update()
