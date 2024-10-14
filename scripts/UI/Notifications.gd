extends Control


@onready var container = $CenterContainer
@onready var catchable_notification = $CenterContainer/NewCatchableNotification
@onready var timer = $Timer

@export var top_offset :float = 120
@export var visibility_duration :float = 3.0
@export var anim_duration :float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.new_lure_registered.connect(on_new_lure_registered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_new_lure_registered(catchable :CatchableRes):
	catchable_notification.set_catchable(catchable)
	start_animation()


func start_animation():
	var initial_pos = container.global_position
	var target_pos = initial_pos
	target_pos.y += top_offset
	
	var tween := get_tree().create_tween().bind_node(container).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(container, "global_position", target_pos, anim_duration)
	tween.play()
	
	await tween.finished
	
	timer.start(visibility_duration)
	await timer.timeout
	
	tween = get_tree().create_tween().bind_node(container).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(container, "global_position", initial_pos, anim_duration)
	tween.play()
	
	await tween.finished
