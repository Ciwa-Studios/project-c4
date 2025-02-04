extends Node2D

@onready var animationPlayer = $AnimationPlayer

@export var player : int
@export var state : String

func _ready() -> void:
	get_parent().connect("health_depleted", health_depleted)
	get_parent().connect("turn_changed", turn_changed)
	get_parent().connect("skill1_used", skill1_used)
	get_parent().connect("skill2_used", skill2_used)
	state = "spawn"

func _process(_delta: float) -> void:
	if state:
		animationPlayer.play(state)

func turn_changed():
	if player == 1:
		if Input.is_action_just_pressed("p1_place"):
			state = "place"
	if player == 2:
		if Input.is_action_just_pressed("p2_place"):
			state = "place"

func skill1_used(p):
	if player == p:
		state = "skill1"

func skill2_used(p):
	if player == p:
		state = "skill2"

func health_depleted(p):
	if player == p:
		state = "hit"

func change_state(new_state : String):
	state = new_state
