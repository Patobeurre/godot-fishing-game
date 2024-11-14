extends HBoxContainer


@onready var image = $Image
@onready var name_label = $NameLabel
@onready var quantity_label = $QuantityLabel
@onready var display_timer = $DisplayTimer

var catchable :CollectedCatchable = null


func _ready() -> void:
	visible = false


func init(c :CollectedCatchable):
	catchable = c
	_update()
	_show()


func _update():
	image.texture = catchable.catchable.image
	name_label.text = catchable.catchable.name
	_update_quantity_label(catchable.amount)


func _update_quantity_label(amount :int):
	if amount > 1:
		quantity_label.text = "x" + str(amount)


func _show():
	visible = true
	display_timer.start()


func _on_display_timer_timeout() -> void:
	queue_free()
