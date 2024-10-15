extends Resource
class_name MailStats


@export var inventory_mails :DocumentList = DocumentList.new()
@export var pending_mails :DocumentList = DocumentList.new()


func add_to_inventory(mail :DocumentRes) -> void:
	if inventory_mails.document_list.has(mail):
		return
	
	inventory_mails.document_list.append(mail)


func add_pending_mails(mails :Array[DocumentRes]) -> void:
	pending_mails.document_list.append_array(mails)


func pop_first() -> DocumentRes:
	return pending_mails.document_list.pop_front()


func has_pending_mail() -> bool:
	return not pending_mails.document_list.is_empty()
