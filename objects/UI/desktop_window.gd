extends Panel

@onready var title :Label = $Title
@onready var contentNode :Control = $Content


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_window(window :WindowContentRes):
	title.text = window.title
	var content = window.content.instantiate()
	contentNode.add_child(content)
	
	content.position = Vector2(0,0)
	content.size = contentNode.size
	visible = true


func on_close_btn_pressed():
	visible = false
