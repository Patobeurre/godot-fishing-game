extends RigidBody2D


@export var target :Node2D
@export var minigame_res :MiniGameDodgeRes
@export var facing_left :bool = false
@export var speed :float = 6

@onready var sprite := $Sprite2D
@onready var state_machine := $FiniteStateMachine
@onready var default_state := $StateDefault
@onready var move_state := $StateMove

var collider :CollisionPolygon2D


func _ready() -> void:
	visible = false

func setup_sprite():
	sprite.texture = minigame_res.minigame_sprite
	sprite.modulate = Color.from_hsv(0, 0, 0)
	sprite.flip_h = facing_left
	_create_polygon2d_nodes_from_sprite2d()
	if facing_left:
		collider.scale.x = collider.scale.y * -1
		collider.position.x += sprite.texture.get_size().x

func init(res :MiniGameDodgeRes, target_node :Node2D, reverse :bool):
	minigame_res = res
	facing_left = minigame_res.facing_left
	setup_sprite()
	set_target(target_node)
	state_machine.set_current_state(default_state)
	visible = true


func set_target(node :Node2D):
	target = node


func look_at_target():
	look_at(target.global_position)


func move_catchable(delta :float):
	move_and_collide(transform.x * speed)


func _create_polygon2d_nodes_from_sprite2d():
	# Destroy Existing Collision Polygons
	for node in $Area2D.find_children("*", "CollisionPolygon2D"):
		node.queue_free()

	# Generate Bitmap from Sprite2D
	var image = sprite.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	
	# Convert Bitmap to Polygons
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, image.get_size()), 0.0)

	# Create CollisionPolygon2D Nodes from Polygons
	for poly in polys:
		collider = CollisionPolygon2D.new()
		collider.polygon = poly
		$Area2D.add_child(collider)
		collider.set_owner(get_tree().get_edited_scene_root())
		collider.position -= sprite.texture.get_size() / 2


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
