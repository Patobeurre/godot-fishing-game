extends Node


@onready var header = $PanelContainer2/MarginContainer/VBoxContainer/Header
@onready var body = $PanelContainer2/MarginContainer/VBoxContainer/Body
@onready var footer = $PanelContainer2/MarginContainer/VBoxContainer/Footer


func fill_content(document :LetterRes):
	header.text = document.header
	body.text = document.body
	footer.text = document.footer
