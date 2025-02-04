extends Panel

@onready var sprite = $Sprite2D

func update(whole : bool):
	if whole:
		sprite.frame = 0
		sprite.show()
	else:
		if sprite.hframes > 1:
			for i in range(sprite.hframes - 1):
				sprite.frame += 1
				await get_tree().create_timer(0.1).timeout
		sprite.hide()
