extends MainUI


@onready var page_container_left = $MarginContainer/MarginContainer/HSplitContainer/PageLeft
@onready var page_container_right = $MarginContainer/MarginContainer/HSplitContainer/PageRight
@onready var book_page = preload("res://objects/UI/book_page.tscn")

var current_page_idx = 0
@export var entries :Array[IdentificationCatchable] = []


func _ready():
	is_activated = true
	update_visible_pages()


func _on_process(delta):
	if Input.is_action_just_pressed("ui_left"):
		previous_page()
	if Input.is_action_just_pressed("ui_right"):
		next_page()


func update_visible_pages():
	var start_idx = current_page_idx * 2
	
	for child in page_container_left.get_children():
		page_container_left.remove_child(child)
	for child in page_container_right.get_children():
		page_container_right.remove_child(child)
	
	var page = book_page.instantiate()
	page_container_left.add_child(page)
	page.init(entries[start_idx])
	
	if start_idx < entries.size() - 1:
		page = book_page.instantiate()
		page_container_right.add_child(page)
		page.init(entries[start_idx+1])


func previous_page():
	if current_page_idx > 0:
		Audio.play("sounds/book/bookFlip1.ogg, sounds/book/bookFlip2.ogg, sounds/book/bookFlip3.ogg")
		current_page_idx -= 1
		update_visible_pages()

func next_page():
	if current_page_idx < (entries.size() - 1) / 2:
		Audio.play("sounds/book/bookFlip1.ogg, sounds/book/bookFlip2.ogg, sounds/book/bookFlip3.ogg")
		current_page_idx += 1
		update_visible_pages()


func _on_activate():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)
