extends Node


var registered_uis :Array[MainUI] = []
var current_ui :MainUI = null
var is_menu_opened :bool = false

signal register(MainUI)
signal unregister(MainUI)

signal on_ui_open(String)
signal on_ui_close(String)


func _ready():
	register.connect(register_new_ui)
	unregister.connect(unregister_new_ui)


func open(id :String):
	if current_ui != null:
		return
	
	for ui in registered_uis:
		if ui.unique_id == id:
			current_ui = ui
			current_ui.activate()
			is_menu_opened = true
			SignalBus.ui_opened.emit()
			return


func close(id :String):
	if current_ui == null:
		return
	
	current_ui.deactivate()
	is_menu_opened = false
	SignalBus.ui_closed.emit()
	current_ui = null


func register_new_ui(ui :MainUI):
	if not registered_uis.has(ui):
		registered_uis.append(ui)

func unregister_new_ui(ui :MainUI):
	var index = registered_uis.find(ui)
	if index >= 0:
		registered_uis.remove_at(index)
