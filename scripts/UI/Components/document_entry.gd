extends Button


@onready var name_label := $MarginContainer/Name

var document :DocumentRes = null


func init(doc :DocumentRes):
	document = doc
	#name_label.text = document.name
	text = document.name
