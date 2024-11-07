extends RigidBody3D
class_name Basket


@onready var interact_body = $StaticBody3D
@onready var interact_collision = $StaticBody3D/CollisionShape3D
@onready var billboard = $Billboard
@onready var animation_player :AnimationPlayer = $AnimationPlayer
@onready var timer :Timer = $Timer

var basket_res :BasketRes = null

var current_area = null
var is_activated = false


func _ready() -> void:
	interact_body.interact_performed.connect(_on_interact)
	billboard.visible = false


func load_from_resource(res :BasketRes):
	basket_res = res
	global_position = res.position
	global_rotation = res.rotation
	is_activated = true


func init():
	basket_res.fish_table = current_area.get_fish_table()
	basket_res.position = global_position
	basket_res.rotation = global_rotation
	BasketManager.register(basket_res)
	is_activated = true


func _process(delta: float) -> void:
	if is_activated:
		is_activated = false
		timer.start(basket_res.basket_type_res.time_interval)


func retreive_basket():
	timer.stop()
	is_activated = false
	FishingManager.add_lures(basket_res.catchables.duplicate(true))
	BasketManager.unregister(basket_res)
	interact_body.interact_performed.disconnect(_on_interact)
	interact_collision.disabled = true
	queue_free()


func _on_timer_timeout() -> void:
	var current_period = TimeManager.get_time_period()
	if not basket_res.is_full():
		basket_res.add_new_catchable(current_period)
		animation_player.play("billboard")
		is_activated = true


func pop_all() -> Array[CollectedCatchable]:
	var collected_catchables = basket_res.catchables.duplicate()
	basket_res.catchables.clear()
	return collected_catchables


func set_res(res :BasketRes):
	basket_res = res


func _on_interact() -> void:
	retreive_basket()


func _on_body_entered(body: Node) -> void:
	linear_velocity = Vector3.ZERO
	gravity_scale = 0
	
	if body.has_method("get_fish_table"):
		current_area = body
		init()
	else:
		queue_free()
