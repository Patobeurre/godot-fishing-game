extends Resource
class_name MiniGameRes

@export_group("Common properties")
@export var acceleration_rate :float = 30.0
@export var deceleration_rate :float = 20.0
@export var miss_deceleration_rate :float = 40.0

@export_group("Moving bars")
@export var bar_move_interval :float = 1.5
@export var bar_speed :float = 5.0

@export_group("Moving cursor")
@export var cursor_speed :float = 1.0
@export var nb_bar_to_spawn :int = 3
