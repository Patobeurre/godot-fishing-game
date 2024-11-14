extends Control


@onready var catchable_notification = $NewCatchableNotificationV2
@onready var multiple_notification_container = $MultipleNotificationContainer
@onready var notification_multiple_item_scene = preload("res://objects/UI/notification_multiple_item.tscn")
@onready var timer = $Timer

@export var top_offset :float = 120
@export var visibility_duration :float = 2.0
@export var anim_duration :float = 1.0

var notification_queue :Array[CatchableRes] = []
var is_in_animation :bool = false


func _ready():
	SignalBus.new_lure_registered.connect(_on_new_lure_registered)
	SignalBus.lure_added.connect(_on_lure_added)
	catchable_notification.animation_finished.connect(_on_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_in_animation:
		return
	
	if not notification_queue.is_empty():
		_show_notification()


func _show_notification():
	is_in_animation = true
	catchable_notification.set_catchable(notification_queue.pop_front())
	catchable_notification.perform_animation()


func _on_animation_finished():
	is_in_animation = false


func _on_new_lure_registered(catchable :CatchableRes):
	notification_queue.append(catchable)


func _on_lure_added(catchable :CollectedCatchable):
	var item = notification_multiple_item_scene.instantiate()
	multiple_notification_container.add_child(item)
	item.init(catchable)
