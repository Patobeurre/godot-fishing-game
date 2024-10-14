extends Control


@onready var window = $Window
@onready var cursor = $Cursor
@onready var item1 = $PanelContainer
@onready var item2 = $PanelContainer2



# Called when the node enters the scene tree for the first time.
func _ready():
	item1.item_clicked.connect(_on_item_clicked)
	window.position = Vector2(5,5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position := get_viewport().get_mouse_position()
	cursor.set_position(mouse_position)


func _on_item_clicked(windowRes :WindowContentRes):
	window.init_window(windowRes)
