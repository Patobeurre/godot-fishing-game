extends Node


@onready var header = $PanelContainer2/MarginContainer/VBoxContainer/Header
@onready var body = $PanelContainer2/MarginContainer/VBoxContainer/Body
@onready var footer = $PanelContainer2/MarginContainer/VBoxContainer/Footer

signal click_outside


func fill_content(document :LetterRes):
	header.text = tr(document.header)
	body.text = tr(document.body)
	footer.text = tr(document.footer)
