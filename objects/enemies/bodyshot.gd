extends StaticBody3D


signal bodyshot

func damage(amount):
	bodyshot.emit(amount)

