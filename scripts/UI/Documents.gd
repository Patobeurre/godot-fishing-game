extends MainUI


@onready var container = $MarginContainer
@onready var showing_await_timer :Timer = $ShowingTimer


var documents_to_show :DocumentList
var current_document :DocumentRes

var is_document_shown :bool = false


func _on_ready() -> void:
	SignalBus.show_documents_request.connect(_on_show_documents_request)


func _on_process(delta):
	if not is_preventing_input and not is_document_shown:
		if Input.is_action_just_pressed("ui_cancel") or \
		Input.is_action_just_pressed("interact"):
			if not try_read_next_document():
				UiManager.close(unique_id)


func _on_input(event):
	if Input.is_action_just_released("interact"):
		is_preventing_input = false
	
	if not is_activated:
		if Input.is_action_just_pressed("interact"):
			is_preventing_input = true


func try_read_next_document() -> bool:
	if documents_to_show.document_list.is_empty():
		return false
	
	current_document = documents_to_show.document_list.pop_front()
	
	if current_document == null:
		return false
	
	show_document()
	return true


func clear_document():
	for child in container.get_children():
		container.remove_child(child)


func show_document():
	clear_document()
	showing_await_timer.start()
	is_document_shown = true
	var document_obj = current_document.scene.instantiate()
	container.add_child(document_obj)
	document_obj.fill_content(current_document)
	Audio.play("sounds/book/bookFlip1.ogg, sounds/book/bookFlip2.ogg, sounds/book/bookFlip3.ogg")


func _on_showing_timer_timeout() -> void:
	is_document_shown = false


func _on_show_documents_request(documents :DocumentList):
	documents_to_show = documents
	UiManager.open(unique_id)


func _on_activate():
	try_read_next_document()
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_fishing.emit(false)

func _on_deactivate():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_fishing.emit(true)
