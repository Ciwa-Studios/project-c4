extends Node2D

export var player:int

onready var animation = $AnimationPlayer
onready var sprite = $Sprite

var character
var playing = true
var prev_health = 3

func _ready():
# warning-ignore:return_value_discarded
	Global.connect("game_over", self, "death")
# warning-ignore:return_value_discarded
	Global.connect("hurt", self, "damaged")
	character = Global.p1_char if player == 1 else Global.p2_char
	animation.play(str(character) + "1")
	if player == 2:
		sprite.scale.x = -1

func _physics_process(_delta):
	if playing:
		if player == 1:
			if Input.is_action_just_pressed("p1enter") and Global.turn == 0:
				animation.play(str(character) + "2")
				animation.queue(str(character) + "1")
		if player == 2:
			if Input.is_action_just_pressed("p2enter") and Global.turn == 1:
				animation.play(str(character) + "2")
				animation.queue(str(character) + "1")

func death():
	if player == 1:
		if Global.p1_health == 0 and animation.get_current_animation() != (str(character) + "7"):
			animation.play(str(character) + "7")
			playing = false
	if player ==2:
		if Global.p2_health == 0 and (animation.get_current_animation() != (str(character) + "7")):
			animation.play(str(character) + "7")
			playing = false

func damaged(p):
	if player == 1 and p == 2:
		if (animation.get_current_animation() != (str(character) + "6")):
			animation.play(str(character) + "6")
			animation.queue(str(character) + "1")
	if player == 2 and p == 1:
		if (animation.get_current_animation() != (str(character) + "6")):
			animation.play(str(character) + "6")
			animation.queue(str(character) + "1")
