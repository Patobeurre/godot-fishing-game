extends Node3D


@export var character :Character

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
	
	MailManager.set_stats(save_game_res.mail_stats)
	TimeManager.set_stats(save_game_res.time_stats)
	FishingManager.set_stats(save_game_res.fishing_stats)
	character.set_stats(save_game_res.character_stats)
	SignalBus.savegame_loaded.emit()
