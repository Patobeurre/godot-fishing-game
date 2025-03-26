extends Resource
class_name MiniGameRes

@export_group("Common properties")
@export var max_score :float = 100.0
@export var acceleration_rate :float = 30.0
@export var deceleration_rate :float = 20.0
@export var miss_deceleration_rate :float = 40.0

@export_group("Moving bars")
@export var bar_move_interval :float = 1.5
@export var bar_speed :float = 5.0

@export_group("Moving cursor")
@export var cursor_speed :float = 1.0
@export var nb_bar_to_spawn :int = 3

@export_group("Moving dots")
@export var dot_initial_offset :float = 200.0
@export var dot_speed :float = 10.0
@export var dot_speed_offset :float = 3.0

@export_group("Round Waves")
@export var wave_cd :float = 2
@export var holes_number :int = 3
@export var rotation_speed :float = 0

@export_group("Round Dodge")
@export var spawn_cd :float = 2.0
@export var catchable_speed :float = 5.0

@export_group("Round Moving Cursor")
@export var round_nb_bar_to_spawn :int = 3
@export var round_cursor_speed :float = 2.0
@export var round_max_time :float = 10
