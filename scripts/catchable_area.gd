extends Node3D
class_name CatchableArea


@onready var self_node :Node3D = self.get_node(".")

@export var fishTable :FishingAreaRes
@export var is_one_shot :bool = false
@export var parent :CatchableArea

var subFishingAreaEntered :CatchableArea
var modifier : FishingAreaModifierRes = null


func _ready():
	fishTable.init()
	SignalBus.bobber_return_to_player.connect(_remove_sub_area)


func prepare():
	pass

func perform():
	pass

func on_finished(succeeded :bool):
	pass


func get_fish_table():
	if subFishingAreaEntered != null:
		return subFishingAreaEntered.get_fish_table()
	
	return fishTable


func enter_sub_fishing_area(subArea :CatchableArea):
	subFishingAreaEntered = subArea

func exit_sub_fishing_area(subArea :CatchableArea):
	if subFishingAreaEntered == subArea:
		subFishingAreaEntered = null


func set_modifier(modifier :FishingAreaModifierRes):
	fishTable.modifier = modifier


func _remove_sub_area():
	exit_sub_fishing_area(subFishingAreaEntered)

func _on_area_entered(area):
	#print("enter area " + fishTable.region.name)
	parent.enter_sub_fishing_area(self)

func _on_area_exited(area):
	#print("exit area " + fishTable.region.name)
	parent.exit_sub_fishing_area(self)
