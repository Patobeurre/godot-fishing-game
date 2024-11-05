extends PanelContainer


@onready var image = $MarginContainer/HBoxContainer/ImageTexture
@onready var name_label = $MarginContainer/HBoxContainer/NameLabel
@onready var amount_label = $MarginContainer/HBoxContainer/AmountLabel
@onready var price_label = $MarginContainer/HBoxContainer/PriceLabel

var catchable :CollectedCatchable = null

signal btn_sell_pressed(CollectedCatchable)


func _ready() -> void:
	SignalBus.fish_selled.connect(_on_fish_selled)


func init(collected_catchable :CollectedCatchable):
	catchable = collected_catchable
	_update()


func _update():
	image.texture = catchable.catchable.image
	name_label.text = tr(catchable.catchable.name)
	amount_label.text = "X " + str(catchable.amount)
	price_label.text = "[b]" + str(catchable.catchable.price) + "[/b] [img]res://sprites/coins.png[/img]"


func _on_fish_selled(collected_catchable):
	if not catchable.catchable == collected_catchable.catchable:
		return
	
	if collected_catchable.amount < 1:
		visible = false
	_update()


func _on_btn_sell_pressed() -> void:
	if catchable.amount > 0:
		btn_sell_pressed.emit(catchable)
