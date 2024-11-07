extends MainUI


@onready var money_label = $GlobalMoneyLabel
@onready var container = $MarginContainer/VSplitContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var sell_menu_btn = $MarginContainer/VSplitContainer/HSplitContainer/SellMenuTab
@onready var buy_menu_btn = $MarginContainer/VSplitContainer/HSplitContainer/BuyMenuTab
@onready var sell_fish_entry_scene = preload("res://objects/UI/SellFishEntry.tscn")
@onready var buy_basket_entry_scene = preload("res://objects/UI/BuyBasketEntry.tscn")


var is_sell_menu_visible :bool = true


func _on_ready() -> void:
	SignalBus.money_changed.connect(_on_money_changed)
	SignalBus.savegame_loaded.connect(_on_savegame_loaded)


func _on_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		UiManager.close(unique_id)


func _sell_fish(collected_catchable :CollectedCatchable):
	FishingManager.remove_lure(collected_catchable)

func _buy_basket(basket :BasketTypeRes):
	if FishingManager.fishing_stats.try_pay(basket.price):
		BasketManager.add_new_basket(basket)


func _clear_entries():
	for fish_entry in container.get_children():
		container.remove_child(fish_entry)


func display_buy_menu():
	is_sell_menu_visible = false
	
	_clear_entries()
	
	var basket_entry = buy_basket_entry_scene.instantiate()
	container.add_child(basket_entry)
	basket_entry.btn_buy_basket_pressed.connect(_buy_basket)
	basket_entry.init(preload("res://scripts/Resources/Baskets/SimpleBasket.tres"))
	basket_entry = buy_basket_entry_scene.instantiate()
	container.add_child(basket_entry)
	basket_entry.btn_buy_basket_pressed.connect(_buy_basket)
	basket_entry.init(preload("res://scripts/Resources/Baskets/MediumBasket.tres"))


func display_sell_menu():
	is_sell_menu_visible = true
	
	_clear_entries()
	
	var fishes = FishingManager \
		.get_all_collected_by_category(CategoryRes.ELureCategory.FISH) \
		.filter(func (fish): return fish.amount > 0)
	for fish in fishes:
		var fish_entry = sell_fish_entry_scene.instantiate()
		container.add_child(fish_entry)
		fish_entry.btn_sell_pressed.connect(_sell_fish)
		fish_entry.init(fish)


func _on_money_changed(amount :int) -> void:
	money_label.text = "[b]" + str(amount) + "[/b] [img]res://sprites/coins.png[/img]"


func _on_savegame_loaded() -> void:
	_on_money_changed(FishingManager.fishing_stats.money)


func _on_activate():
	display_sell_menu()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.enable_player_camera.emit(false)
	SignalBus.enable_player_fishing.emit(false)
	SignalBus.enable_player_movements.emit(false)

func _on_deactivate():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SignalBus.enable_player_camera.emit(true)
	SignalBus.enable_player_fishing.emit(true)
	SignalBus.enable_player_movements.emit(true)


func _on_sell_menu_btn_pressed() -> void:
	if not is_sell_menu_visible:
		display_sell_menu()


func _on_buy_menu_btn_pressed() -> void:
	if is_sell_menu_visible:
		display_buy_menu()
