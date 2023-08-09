extends Control

export var ability = 1
onready var bar = $ProgressBar
onready var bg = $Sprite
onready var icon = $Icons
onready var update_tween = $UpdateTween
var ability_cooldown
var ability_type


func _ready():
	if ability == 1:
		ability_cooldown = Global.p1_cooldown_s1
		ability_type = Global.p1_s1
	if ability == 2:
		ability_cooldown = Global.p1_cooldown_s2
		ability_type = Global.p1_s2
	bar.max_value = ability_cooldown
	icon.frame = ability_type


func _physics_process(_delta):
	if ability == 1:
		ability_cooldown = Global.p1_cooldown_s1
	if ability == 2:
		ability_cooldown = Global.p1_cooldown_s2
	if ability_cooldown != bar.max_value:
		bar.value = bar.max_value - ability_cooldown
	else:
		update_tween.interpolate_property(bar, "value", bar.value, bar.max_value - ability_cooldown, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		update_tween.start()

func _input(event):
	if (event.is_action_pressed("p1skill1")  and ability == 1) or (event.is_action_pressed("p1skill2") and ability == 2) and ability_cooldown != 0:
		bg.animation = "!ready"




func _on_Sprite_animation_finished():
	bg.animation = "Idle"
