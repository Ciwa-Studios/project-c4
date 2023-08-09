extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var counterTypes = $CounterTypes
onready var Effect = preload("res://Scenes/Effects/P2DeathEffect.tscn").instance()

var counter = 0
var pos

var target_r = Global.ROWS - 1

func _ready():
	Global.connect("turn_change", self, "next_turn")
	animationPlayer.playback_speed = 1.0
	counter = Global.counter
	pos = Global.positions[len(Global.positions) - 1]
	counterTypes.play(str(counter))

func next_turn():
	if counter == 1 and pos.y != 9:
		if !Global.check_for_counter(pos.y + 1, pos.x):
			Global.winning_move()
			Global.destroy_block(pos)
			for r in range(pos.y , Global.ROWS):
				if Global.check_for_counter(r, pos.x):
					target_r = r - 1
					break
			Global.place_counter_no_skip(target_r, pos.x, 2, 1)
			

func death():
	Effect.position = self.position
	get_parent().add_child(Effect)
	queue_free()
	if counter == 2:
		for r in range(pos.y , Global.ROWS):
			if Global.check_for_counter(r, pos.x):
				target_r = r - 1
				break
		Global.place_counter_no_skip(target_r, pos.x, 2, 1)
	if counter == 3:
		Global.place_counter_no_skip(pos.y, pos.x, 2, 0)
