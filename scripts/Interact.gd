extends RayCast3D


@onready var label_txt = $InteractUI/AspectRatioContainer/Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var coll = self.get_collider();
	
	if self.is_colliding():
		if coll.is_in_group("Interactable"):
			$InteractUI.show();
			label_txt.text = "[E] " + coll.get_meta("label");
			if Input.is_action_just_pressed("interact"):
				coll.interact();
	else:
		$InteractUI.hide();
