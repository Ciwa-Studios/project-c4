extends Node2D

onready var p1 = $P1Win
onready var p2 = $P2Win 
onready var timer = $Timer
onready var animation = $"../../CanvasLayer/AnimationPlayer"
onready var transition = $"../../CanvasLayer/Transition"

func _ready():
# warning-ignore:return_value_discarded
	Global.connect("game_over", self, "win")
	transition.visible = true

func win():
	var winner = Global.winner
	if winner == 1:
		p1.visible = true
		timer.start()
	elif winner == 2:
		p2.visible = true
		timer.start()
	else:
		p1.visible = false
		p2.visible = false

func return_to_menu():
	Global.reset()
	animation.play("RESET")
	transition.visible = false
	Global.play = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_Timer_timeout():
	animation.play("End")

