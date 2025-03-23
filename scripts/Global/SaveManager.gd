extends Node3D


@export var character :Player

var save_game_res :SaveGameStats


func _ready():
	SignalBus.save_requested.connect(save)
	_create_or_load_save()


func save():
	save_game_res.write_savegame()


func _create_or_load_save() -> void:
	if SaveGameStats.save_exists():
		save_game_res = SaveGameStats.load_savegame()
	else:
		save_game_res = SaveGameStats.new()
		
	ProgressVariables.set_stats(save_game_res.progress_variables_stats)
	MailManager.set_stats(save_game_res.mail_stats)
	TimeManager.set_stats(save_game_res.time_stats)
	FishingManager.set_stats(save_game_res.fishing_stats)
	BasketManager.set_stats(save_game_res.basket_stats)
	character.set_stats(save_game_res.character_stats)
	character.enable_player(false)
	SignalBus.savegame_loaded.emit()
