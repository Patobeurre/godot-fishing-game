extends Node


var mail_list :DocumentList = preload("res://scripts/Resources/Documents/AllDocuments.tres")
var pending_mails :DocumentList

signal mail_received


func _ready() -> void:
	pending_mails = DocumentList.new()
	TimeManager.new_day.connect(on_new_day)
	on_new_day(1)


func on_new_day(day_count :int):
	var available_mails = mail_list.document_list.filter(func (mail): 
		return mail.receive_day_count == day_count)
	
	pending_mails.document_list.append_array(available_mails)
	if not available_mails.is_empty():
		mail_received.emit()


func get_next_mail() -> DocumentRes:
	if not has_pending_mail(): return null
	
	var mail = pending_mails.document_list.pop_front()
	return mail

func has_pending_mail() -> bool:
	return not pending_mails.document_list.is_empty()
