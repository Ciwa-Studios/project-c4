extends Control

onready var bar = $ProgressBar
onready var update_tween = $UpdateTween
onready var hit = get_parent().get_node("Hit")

var health = Global.p2_health

func _physics_process(_delta):
	if health != Global.p2_health:
		update_tween.interpolate_property(bar, "value", health, Global.p2_health, 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		update_tween.start()
		hit.play()
		health = Global.p2_health
