extends Node3D


@onready var mail_billboard = $MeshInstance3D
@onready var animation_player :AnimationPlayer = $AnimationPlayer
@onready var interact_body = $mailbox/StaticBody3D
@onready var letter_mesh = $letter


func _ready() -> void:
	interact_body.interact_performed.connect(interact)
	MailManager.mail_received.connect(on_mail_received)
	SignalBus.savegame_loaded.connect(on_mail_received)
	
	animation_player.play("up_and_down")
	display_mail_billboard(false)


func on_mail_received():
	if not MailManager.has_pending_mail() :
		return
	
	display_mail_billboard(true)


func display_mail_billboard(enabled :bool):
	mail_billboard.visible = enabled
	letter_mesh.visible = enabled


func interact():
	if MailManager.has_pending_mail():
		display_mail_billboard(false)
		UiManager.open("Documents")
