extends Node
class_name Letter


@onready var header = $MarginContainer/VBoxContainer/Header
@onready var body = $MarginContainer/VBoxContainer/Body
@onready var footer = $MarginContainer/VBoxContainer/Footer


func fill_content(document :LetterRes):
	header.text = document.header
	body.text = document.body
	footer.text = document.footer
