extends PanelContainer


@onready var icon = $VSplitContainer/Icon
@onready var label = $VSplitContainer/Label
@export var res :IconDesktopRes

var stylebox_hover :StyleBoxFlat

signal item_clicked(WindowContentRes)


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = res.name
	icon.texture = res.icon
	stylebox_hover = StyleBoxFlat.new()
	stylebox_hover.bg_color = Color.from_string("39ff33", Color.GREEN)


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	label.add_theme_stylebox_override("normal", stylebox_hover)
	label.add_theme_color_override("font_color", Color.BLACK)


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	label.remove_theme_stylebox_override("normal")
	label.add_theme_color_override("font_color", Color.from_string("39ff33", Color.GREEN))


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		item_clicked.emit(res.content)
