extends Button
class_name DocumentEntry


@onready var name_label := $MarginContainer/Name

var document :DocumentRes = null

signal item_clicked(DocumentRes)


func init(doc :DocumentRes):
	document = doc
	text = document.name


func _on_pressed() -> void:
	item_clicked.emit(document)
