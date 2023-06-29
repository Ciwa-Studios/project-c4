extends Node2D

onready var p1 = $P1Win
onready var p2 = $P2Win 
onready var timer = $Timer

func _ready():
# warning-ignore:return_value_discarded
	Global.connect("game_over", self, "win")

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


func _on_Timer_timeout():
	Global.play = false
	get_tree().change_scene("res://UiScenes/MainMenu.tscn")
