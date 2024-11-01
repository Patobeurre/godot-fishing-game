extends Control


@onready var fish_collection = $FishCollection
@onready var identification_book = $IdentificationBook
@onready var crosshair = $CenterContainer/TextureRect


func _ready() -> void:
	identification_book.visible = false
	ProgressVariables.progress_variable_updated.connect(_on_progress_variable_updated)


func _on_progress_variable_updated(variable_name :String) -> void:
	identification_book.visible = ProgressVariables.check_variable("identification_book_obtained", true)


func enable_crosshair(enabled : bool) -> void:
	crosshair.visible = enabled
