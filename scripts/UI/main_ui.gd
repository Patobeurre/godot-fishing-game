extends Control
class_name MainUI


@export var unique_id :String

var is_activated :bool = false
var is_preventing_input :bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	is_activated = false
	visible = false
	UiManager.register.emit(self)
	_on_ready()

func _process(delta):
	if not is_activated: return
	_on_process(delta)

func _physics_process(delta):
	if not is_activated: return
	_on_physics_process(delta)

func _input(event):
	#if not is_activated: return
	_on_input(event)


func activate():
	visible = true
	is_activated = true
	UiManager.on_ui_open.emit(unique_id)
	_on_activate()

func deactivate():
	visible = false
	is_activated = false
	UiManager.on_ui_close.emit(unique_id)
	_on_deactivate()


func _on_ready():
	pass

func _on_process(delta):
	pass

func _on_physics_process(delta):
	pass

func _on_input(event):
	pass

func _on_activate():
	pass

func _on_deactivate():
	pass
