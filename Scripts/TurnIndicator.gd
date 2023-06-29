extends Node2D

onready var animation = $AnimationPlayer

var turn 


func _ready():
# warning-ignore:return_value_discarded
	Global.connect("turn_change", self, "color_change")
# warning-ignore:return_value_discarded
	Global.connect("game_over", self, "color_over")

func color_change():
	turn = Global.turn
	if turn == 0 and Global.game_over == false:
		animation.play("red_to_blue")
	if turn == 1 and Global.game_over == false:
		animation.play("blue_to_red")
	pass

func color_over():
	if Global.p1_health == 0:
		animation.play("blue_to_red")
	if Global.p2_health == 0:
		animation.play("red_to_blue")
