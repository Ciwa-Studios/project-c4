extends Control

onready var bar = $ProgressBar
onready var update_tween = $UpdateTween

var health = Global.p1_health

func _physics_process(_delta):
	if health != Global.p1_health:
		update_tween.interpolate_property(bar, "value", health, Global.p1_health, 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		update_tween.start()
		health = Global.p1_health
