extends TextureButton


@onready var label :RichTextLabel = $CenterContainer/RichTextLabel

@export var category :CategoryRes


func _ready():
	pass
	#label.text = category.name


func update(categories :Array[CategoryRes]):
	if categories.has(category):
		visible = true
	
