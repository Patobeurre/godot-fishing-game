extends Area3D


func _on_area_entered(area: Area3D) -> void:
	SignalBus.player_enter_ladder.emit(true)


func _on_area_exited(area: Area3D) -> void:
	SignalBus.player_enter_ladder.emit(false)


func _on_body_entered(body: Node3D) -> void:
	SignalBus.player_enter_ladder.emit(true)


func _on_body_exited(body: Node3D) -> void:
	SignalBus.player_enter_ladder.emit(false)
