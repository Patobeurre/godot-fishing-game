extends MainUI
class_name DocumentsCollection


@onready var container = $HSplitContainer/MarginContainer/VSplitContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var document_preview = $DocumentPreview
@onready var document_view = $DocumentPreview/View
@onready var document_entry_scene :PackedScene = preload("res://objects/UI/DocumentEntry.tscn")


func _on_process(delta):
	if not is_preventing_input:
		if Input.is_action_just_pressed("ui_cancel"):
			UiManager.close(unique_id)

func _on_input(event):
	if Input.is_action_just_released("interact"):
		is_preventing_input = false
	
	if not is_activated:
		if Input.is_action_just_pressed("interact"):
			is_preventing_input = true


func populate():
	for node in container.get_children():
		node.disconnect("item_clicked", _on_document_clicked)
		container.remove_child(node)
	
	for mail in MailManager.get_inventory_mails().document_list:
		var item = document_entry_scene.instantiate() as DocumentEntry
		container.add_child(item)
		item.init(mail)
		item.item_clicked.connect(_on_document_clicked)


func show_document_preview(document :DocumentRes):
	var document_scene = document.scene.instantiate()
	document_view.add_child(document_scene)
	document_scene.fill_content(document)
	document_preview.visible = true


func _on_document_clicked(document :DocumentRes):
	show_document_preview(document)


func _on_activate():
	populate()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)


func _on_click_outside_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		for node in document_view.get_children():
			document_view.remove_child(node)
		document_preview.visible = false
