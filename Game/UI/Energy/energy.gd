extends Panel

@onready var sprite = $Sprite2D

func update(whole : bool):
	if whole:
		sprite.frame = 0
		sprite.show()
	else:
		sprite.hide()
		
