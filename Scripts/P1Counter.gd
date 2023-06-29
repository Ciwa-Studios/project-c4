extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var counterTypes = $CounterTypes
onready var Effect = preload("res://Scenes/Effects/P1DeathEffect.tscn").instance()

var counter = 0
var pos

var target_r = Global.ROWS - 1

func _ready():
	animationPlayer.playback_speed = 1.0
	counter = Global.counter
	pos = Global.positions[len(Global.positions) - 1]
	counterTypes.play(str(counter))

func _physics_process(_delta):
	if counter == 1 and pos.y != 9:
		if !Global.check_for_counter(pos.y + 1, pos.x):
			Global.winning_move()
			Global.destroy_block(pos)
			for r in range(pos.y , Global.ROWS):
				if Global.check_for_counter(r, pos.x):
					target_r = r - 1
					break
			Global.place_counter_no_skip(target_r, pos.x, 1, 1)

func death():
	Effect.position = self.position
	get_parent().add_child(Effect)
	queue_free()
