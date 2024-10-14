extends Node3D


@onready var mail_billboard = $MeshInstance3D
@onready var animation_player :AnimationPlayer = $AnimationPlayer
@onready var interact_body = $mailbox/StaticBody3D
@onready var letter_mesh = $letter


func _ready() -> void:
	interact_body.interact_performed.connect(interact)
	MailManager.mail_received.connect(on_mail_received)
	animation_player.play("up_and_down")


func on_mail_received():
	mail_billboard.visible = true
	letter_mesh.visible = true

func interact():
	if MailManager.has_pending_mail():
		SignalBus.update_document_list.emit(MailManager.pending_mails)
		mail_billboard.visible = false
		letter_mesh.visible = false
		UiManager.open("Documents")
