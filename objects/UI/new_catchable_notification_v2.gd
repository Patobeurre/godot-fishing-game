extends Control


@export var anim_speed :float = 2.0
@export var anim_image_duration :float = 1.0
@export var anim_label_duration :float = 1.0
@export var stay_visible_duration :float = 1.0
@export var max_scale := Vector2(13, 13)

@onready var container = $CenterContainer2/Panel
@onready var stary_background :Sprite2D = $CenterContainer2/Panel/StaryBackground
@onready var image_container = $CenterContainer2/Panel/TextureRect
@onready var label :Label = $CenterContainer3/RichTextLabel
@onready var timer :Timer = $Timer

var catchable :CatchableRes


# Called when the node enters the scene tree for the first time.
func _ready():
	label.modulate.a = 0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stary_background.rotation += anim_speed * delta


func set_catchable(newCatchable :CatchableRes):
	catchable = newCatchable
	update()

func update():
	image_container.texture = catchable.image
	label.text = tr(catchable.name)


func perform_animation():
	visible = true
	container.scale = Vector2.ZERO
	var tween := get_tree().create_tween().bind_node(container).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(container, "scale", max_scale, anim_image_duration)
	container.visible = true
	tween.play()
	
	await tween.finished
	
	var initial_pos = label.position
	var target_pos = initial_pos
	var target_modulate = label.modulate
	target_modulate.a = 1
	target_pos.y += 200
	var tween_label = get_tree().create_tween().bind_node(label).set_trans(Tween.TRANS_ELASTIC)
	tween_label.parallel().tween_property(label, "position", target_pos, anim_label_duration)
	tween_label.parallel().tween_property(label, "modulate", target_modulate, anim_label_duration)
	tween_label.play()
	
	await tween_label.finished
	
	
	timer.start(stay_visible_duration)
	await timer.timeout
	
	target_modulate.a = 0
	tween = get_tree().create_tween().bind_node(container).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(container, "scale", Vector2.ZERO, anim_image_duration)
	tween.parallel().tween_property(label, "position", initial_pos, anim_label_duration)
	tween.parallel().tween_property(label, "modulate", target_modulate, anim_label_duration)
	tween.play()
	
	await tween.finished
	visible = false
