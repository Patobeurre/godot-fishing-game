extends Node


var mail_list :DocumentList = preload("res://scripts/Resources/Documents/AllMailList.tres")
var mail_stats :MailStats

signal mail_received


func _ready() -> void:
	TimeManager.new_day.connect(on_new_day)


func on_new_day(day_count :int):
	var available_mails = mail_list.document_list.filter(func (mail): 
		return mail.receive_day_count == day_count)
	
	mail_stats.add_pending_mails(available_mails)
	
	if not available_mails.is_empty():
		mail_received.emit()


func add_documents_to_inventory(documents :DocumentList):
	for document in documents.document_list:
		mail_stats.add_to_inventory(document)


func get_next_mail() -> DocumentRes:
	if not mail_stats.has_pending_mail(): return null
	
	var mail = mail_stats.pop_first()
	mail_stats.add_to_inventory(mail)
	return mail


func get_inventory_mails() -> DocumentList:
	return mail_stats.inventory_mails


func get_pending_mails() -> DocumentList:
	return mail_stats.pending_mails


func has_pending_mail() -> bool:
	return mail_stats.has_pending_mail()


func set_stats(stats :MailStats) -> void:
	mail_stats = stats
