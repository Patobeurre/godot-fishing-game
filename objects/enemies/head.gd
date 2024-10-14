extends StaticBody3D


signal headshot

func damage(amount):
	headshot.emit(amount*2)
