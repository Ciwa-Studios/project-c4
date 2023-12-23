extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var counterTypes = $CounterTypes
onready var Effect = preload("res://Scenes/Effects/P1DeathEffect.tscn").instance()

var counter = 0
var lifetime = 0
var pos

var target_r = Global.ROWS - 1

func _ready():
	Global.connect("turn_change", self, "next_turn")
	animationPlayer.playback_speed = 1.0
	counter = Global.counter
	pos = Global.positions[len(Global.positions) - 1]
	counterTypes.play(str(counter))
	if counter == 4:
		lifetime = 6

func next_turn():
	if counter == 4:
		lifetime -= 1
		if lifetime == 0:
			for r in Global.ROWS:
				Global.destroy_block(Vector2(pos.x, r))
			death()
	if counter == 1 and pos.y != 9:
		if !Global.check_for_counter(pos.y + 1, pos.x):
			for r in range(pos.y , Global.ROWS):
				if Global.check_for_counter(r, pos.x):
					target_r = r - 1
					break
			Global.place_counter_no_skip(target_r, pos.x, 3, 1)
	pass

func death():
	Effect.position = self.position
	get_parent().add_child(Effect)
	queue_free()
