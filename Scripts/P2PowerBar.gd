extends Control

export var ability = 1
onready var bar = $ProgressBar
onready var bg = $Sprite
onready var icon = $Icons
var ability_cooldown
var ability_type

func _ready():
	if ability == 1:
		ability_cooldown = Global.p2_cooldown_s1
		ability_type = Global.p2_s1
	if ability == 2:
		ability_cooldown = Global.p2_cooldown_s2
		ability_type = Global.p2_s2
	bar.max_value = ability_cooldown
	icon.frame = ability_type


func _physics_process(_delta):
	if ability == 1:
		ability_cooldown = Global.p2_cooldown_s1
	if ability == 2:
		ability_cooldown = Global.p2_cooldown_s2
	bar.value = bar.max_value - ability_cooldown

func _input(event):
	if event.is_action_pressed("p2skill1") and ability == 1 and ability_cooldown != 0:
		bg.animation = "!ready"
	if event.is_action_pressed("p2skill2") and ability == 2 and ability_cooldown != 0:
		bg.animation = "!ready"

func _on_Sprite_animation_finished():
	bg.animation = "Idle"
