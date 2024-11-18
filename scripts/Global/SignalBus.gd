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
signal lure_added(CollectedCatchable)
signal new_lure_registered(CatchableRes)
signal cancel_fishing

signal show_documents_request(DocumentList)

signal basket_added(BasketRes)
signal basket_available(bool)

signal time_changed(float)
signal time_period_changed(ETimePeriod)

signal update_document_list(DocumentList)
signal validate_identification()
signal fish_selled(CollectedCatchable)
signal money_changed(int)

signal player_pos_update(Vector3)

signal enable_player_movements(bool)
signal enable_player_camera(bool)
signal enable_player_fishing(bool)
signal enable_player_hud(bool)

signal hide_sun(bool)

signal interact_request(Camera3D)
signal end_camera_interaction()
signal end_interaction()

signal ui_opened
signal ui_closed

signal save_requested
signal savegame_loaded
