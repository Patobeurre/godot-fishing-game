extends Resource
class_name DocumentList


@export var document_list :Array[DocumentRes] = []


static func create(documents :Array[DocumentRes]) -> DocumentList:
	var list = DocumentList.new()
	list.document_list = documents
	return list
