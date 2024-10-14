extends Node


signal bobber_enter_fishing_area(FishingAreaRes)
signal bobber_collide_wall
signal bobber_return_to_player
signal bobber_has_catched(CatchableRes)

signal start_minigame()
signal end_minigame(bool)
signal minigame_score_updated(float)
signal catching_started
signal catching_finished(bool)
signal open_lure_collection()
signal close_lure_collection()
signal new_lure_registered(CatchableRes)
signal cancel_fishing

signal update_document_list(DocumentList)

signal player_pos_update(Vector3)

signal enable_player_movements(bool)
signal enable_player_camera(bool)
signal enable_player_fishing(bool)

signal save_requested
signal savegame_loaded
