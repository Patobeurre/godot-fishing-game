extends MainUI


@onready var page_container_left = $MarginContainer/MarginContainer/HSplitContainer/PageLeft
@onready var page_container_right = $MarginContainer/MarginContainer/HSplitContainer/PageRight
@onready var selection_panel = $PanelContainer
@onready var selection_menu_left = $PanelContainer/MarginContainer2/HBoxContainer/PanelContainer/SelectionPanelLeft
@onready var selection_menu_right = $PanelContainer/MarginContainer2/HBoxContainer/PanelContainer2/SelectionPanelRight
@onready var validation_container = $ValidationPanel
@onready var validation_entries = $ValidationPanel/MarginContainer/MarginContainer/NewlyValidatedEntries

@onready var book_page = preload("res://objects/UI/book_page.tscn")
@onready var validation_entry = preload("res://objects/UI/ident_validation_entry.tscn")

var current_page_idx = 0
var selected_page :IdentificationPage = null


func _on_ready():
	validation_container.visible = false
	selection_menu_left.item_clicked.connect(_on_fish_selected)
	selection_menu_right.item_clicked.connect(_on_fish_selected)
	SignalBus.validate_identification.connect(_on_validate_identification)


func _on_process(delta):
	if not is_preventing_input:
		if Input.is_action_just_pressed("ui_cancel") or \
		Input.is_action_just_pressed("open_identification_book"):
			UiManager.close(unique_id)
	
	if Input.is_action_just_pressed("ui_left"):
		previous_page()
	if Input.is_action_just_pressed("ui_right"):
		next_page()


func _on_input(event):
	if Input.is_action_just_released("open_identification_book"):
		is_preventing_input = false
	
	if not is_activated:
		if Input.is_action_just_pressed("open_identification_book"):
			is_preventing_input = true


func _on_page_clicked(page :IdentificationPage):
	selected_page = page
	selection_menu_right.visible = not page.is_page_right
	selection_menu_left.visible = page.is_page_right
	selection_panel.visible = true


func update_visible_pages():
	var start_idx = current_page_idx * 2
	
	for child in page_container_left.get_children():
		child.disconnect("btn_fish_clicked", _on_page_clicked)
		page_container_left.remove_child(child)
	for child in page_container_right.get_children():
		child.disconnect("btn_fish_clicked", _on_page_clicked)
		page_container_right.remove_child(child)
	
	var page = book_page.instantiate()
	page_container_left.add_child(page)
	page.btn_fish_clicked.connect(_on_page_clicked)
	page.init(FishingManager.get_identification_list()[start_idx], false)
	
	if start_idx < FishingManager.get_identification_list().size() - 1:
		page = book_page.instantiate()
		page_container_right.add_child(page)
		page.btn_fish_clicked.connect(_on_page_clicked)
		page.init(FishingManager.get_identification_list()[start_idx+1], true)


func previous_page():
	if current_page_idx > 0:
		Audio.play("sounds/book/bookFlip1.ogg, sounds/book/bookFlip2.ogg, sounds/book/bookFlip3.ogg")
		current_page_idx -= 1
		update_visible_pages()

func next_page():
	if current_page_idx < (FishingManager.get_identification_list().size() - 1) / 2:
		Audio.play("sounds/book/bookFlip1.ogg, sounds/book/bookFlip2.ogg, sounds/book/bookFlip3.ogg")
		current_page_idx += 1
		update_visible_pages()


func init_selection_menus() -> void:
	selection_panel.hide()
	selection_menu_left.populate()
	selection_menu_right.populate()


func _on_activate():
	init_selection_menus()
	update_visible_pages()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)


func _on_panel_container_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		selection_panel.visible = false


func _on_fish_selected(catchable :CollectedCatchable) -> void:
	selected_page.set_selected_catchable(catchable.catchable)
	selection_panel.visible = false
	FishingManager.verify_identification_list()


func _on_validate_identification():
	var newly_identified_list = FishingManager.verified_list
	
	for child in validation_entries.get_children():
		validation_entries.remove_child(child)
		
	for item in newly_identified_list:
		var entry = validation_entry.instantiate() as IdentificationValidatedEntry
		validation_entries.add_child(entry)
		entry.init(item.catchable)
	
	validation_container.visible = true


func _on_validation_panel_gui_input(event: InputEvent) -> void:
	validation_container.visible = false
